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

@implementation AccountManager

@synthesize currentBalance;
@synthesize numOfTransactions;

- (id)init
{
    if (self == [super init]) {
        //Set initial balance
        currentBalance = [NSNumber numberWithDouble:kStartingBalance];
        numOfTransactions = [NSNumber numberWithDouble:kStartingTransactions];
        
    }
    
    return self;
    
}

//Update current balance with submitted amount
- (void)postTransaction:(double)submittedAmount
{
    double currentAmount = [currentBalance doubleValue];
    
    currentAmount += submittedAmount;
    
    currentBalance = [NSNumber numberWithDouble:currentAmount];
    NSLog(@"currentBalance: %@", currentBalance);
}

- (void)incrementTransactionCount
{
    double transactionCount = [numOfTransactions doubleValue];
    transactionCount++;
    numOfTransactions = [NSNumber numberWithDouble:transactionCount];
}

@end
