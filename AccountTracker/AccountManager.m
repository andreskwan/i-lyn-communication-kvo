//
//  AccountManager.m
//  AccountTracker
//
//  Created by Ron Buencamino on 6/25/15.
//  Copyright (c) 2015 Globe Bank. All rights reserved.
//

#import "AccountManager.h"

static double kStartingBalance = 5000;
static double kStartingTransactions = 0;

/*
 Allows refactoring
 - just one change in our code if we want to change the name
 - avoid typos
 */
static NSString *kCurrentBalanceKeyPath = @"currentBalance";
static NSString *kCurrentNumOfTransactionsKeyPath = @"numOfTransactions";

static NSString *kSubmitNotification = @"SubmitNotification";

@implementation AccountManager

@synthesize currentBalance;
@synthesize numOfTransactions;

- (id)init
{
    if (self == [super init]) {
        //Set initial balance
        currentBalance = [NSNumber numberWithDouble:kStartingBalance];
        numOfTransactions = [NSNumber numberWithDouble:kStartingTransactions];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveSubmitNotification:)
                                                     name:kSubmitNotification
                                                   object:nil];
        
    }
    
    return self;
    
}

//Update current balance with submitted amount
- (void)postTransaction:(double)submittedAmount
{
    double currentAmount = [currentBalance doubleValue];
    
    currentAmount += submittedAmount;
    
    //UI should be informed that this change took place.
    //So we need to use KVO
    //we must change the implementation
    //    currentBalance = [NSNumber numberWithDouble:currentAmount];
    // this also fire off the notification to all observers
    [self setValue:[NSNumber numberWithDouble:currentAmount] forKey:kCurrentBalanceKeyPath];
    
    NSLog(@"currentBalance: %@", currentBalance);
}

- (void)incrementTransactionCount
{
    double transactionCount = [numOfTransactions doubleValue];
    transactionCount++;
//    numOfTransactions = [NSNumber numberWithDouble:transactionCount];
    [self setValue:[NSNumber numberWithDouble:transactionCount] forKey:kCurrentNumOfTransactionsKeyPath];
}

/**
 * method to call incrementTransactionCount
 * @param needed to access the notification info
 */
- (void)didReceiveSubmitNotification:(NSNotification *)notification
{
    [self incrementTransactionCount];
}

@end
