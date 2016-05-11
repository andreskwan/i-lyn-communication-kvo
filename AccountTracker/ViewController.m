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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
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
    currentBalanceLbl.text = [self currentBalanceString];
    
    dateLbl.text = [NSString stringWithFormat:@"As of %@ \t\t %@", [self getCurrentDate], [self getTransactionCount]];
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




@end
