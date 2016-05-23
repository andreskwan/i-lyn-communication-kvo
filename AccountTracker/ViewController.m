//
//  ViewController.m
//  AccountTracker
//
//  Created by Ron Buencamino on 6/25/15.
//  Copyright (c) 2015 Globe Bank. All rights reserved.
//

#import "ViewController.h"
#import "AccountManager.h"

#define kCurrentBalancePrefix @"Current Balance: "

static NSString *kCurrentBalanceKeyPath = @"currentBalance";
static NSString *kCurrentNumOfTransactionsKeyPath = @"numOfTransactions";
static NSString *kSubmitNotification = @"SubmitNotification";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, AccountManagerDelegate>
{
    __weak IBOutlet UITextField *amountInputTF;
    __weak IBOutlet UIButton *submitBtn;
    __weak IBOutlet UILabel *currentBalanceLbl;
    __weak IBOutlet UILabel *successLbl;
    __weak IBOutlet UIImageView *logoImageView;
    __weak IBOutlet UILabel *dateLbl;
    __weak IBOutlet UITableView *historyTableView;
}

@property (nonatomic, strong) AccountManager *account;
@property (nonatomic, strong) NSMutableArray *transactionHistory;

@end

@implementation ViewController
@synthesize account, transactionHistory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectNull];
    transactionHistory = [NSMutableArray array];
    
    //Initialize BankAccount object
    account = [[AccountManager alloc] init];
    account.delegate = self;
    
    currentBalanceLbl.text = [self currentBalanceString];
    
    dateLbl.text = [self updateDateAndTransactionCountLabel];
    
    /*
     Add this object as observer to the account manager object
     */
    [account addObserver:self
              forKeyPath:kCurrentBalanceKeyPath
                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:nil];
    [account addObserver:self
              forKeyPath:kCurrentNumOfTransactionsKeyPath
                 options:NSKeyValueObservingOptionNew
                 context:nil];
    
    /*
     Subscribe to notifications
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveSubmitNotification:)
                                                 name:kSubmitNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *currentDate = [formatter stringFromDate:date];
    return currentDate;
}

- (NSString *)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

/*
 Helper method to convert from number to string
 */
- (NSString *)currentBalanceString
{
    NSString *string = [NSString stringWithFormat:@"%@ %@", kCurrentBalancePrefix, [self formatNumber:account.currentBalance]];
    return string;
}

- (NSString *)getTransactionCount
{
    NSString *string = [NSString stringWithFormat:@"Number of Transactions: %@", account.numOfTransactions];
    return string;
}

- (NSString *)formatNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *formattedAmount = [formatter stringFromNumber:number];
    return formattedAmount;
}

- (IBAction)submitAction:(id)sender
{
    //Do Something
    [self postTransaction];
    
    amountInputTF.text = nil;
    
    /**
     Post a notification after submit
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:kSubmitNotification
                                                        object:nil];
}

- (void)postTransaction
{
    double transactionAmount = [amountInputTF.text doubleValue];
    [account postTransaction:transactionAmount];
}

//UITableViewDataSource and UITableViewDelegate Methods
#pragma mark - UITableView Stuff
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionHistory count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Recent Transactions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    return cell;
}


/*
 this method is called when a change in the observed parameter occurs
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kCurrentBalanceKeyPath]) {
        //Update current balance label text color
        //red or black
        double balance = [account.currentBalance doubleValue];
        if (balance < 0) {
            //Turn red
            currentBalanceLbl.textColor = [UIColor redColor];
        } else {
            //Keep black
            currentBalanceLbl.textColor = [UIColor blackColor];
        }
        //Update current balance text value
        currentBalanceLbl.text = [self currentBalanceString];
        
    }
    if ([keyPath isEqualToString:kCurrentNumOfTransactionsKeyPath]) {
        
        dateLbl.text = [self updateDateAndTransactionCountLabel];
    }
}

/*
 Helper method created to avoid code repetition
 */
- (NSString *)updateDateAndTransactionCountLabel
{
    return [NSString stringWithFormat:@"As of %@ \t\t %@", [self getCurrentDate], [self getTransactionCount]];
}

/**
 * label animation
 */
- (void)showSuccessLabel
{
    //1 set text property
    successLbl.text = @"Transaction Submitted";
    //2 set the alpha
    successLbl.alpha = 1.0f;
    
    //3 the animation for text alpha - to disappear message after a few seconds
    [UIView animateWithDuration:2.0
                     animations:^{
                         successLbl.alpha = 0.0f;
                     }];
}

/**
 * method to call showSuccessLabel
 * @param needed to access the notification info
 */
- (void)didReceiveSubmitNotification:(NSNotification *)notification
{
    [self showSuccessLabel];
}

@end
