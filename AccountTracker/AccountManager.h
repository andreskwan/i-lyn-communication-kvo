//
//  AccountManager.h
//  AccountTracker
//
//  Created by Ron Buencamino on 6/25/15.
//  Copyright (c) 2015 Globe Bank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

@property (nonatomic, strong) NSNumber *currentBalance;
@property (nonatomic, strong) NSNumber *numOfTransactions;

- (void)postTransaction:(double)submittedAmount;

@end
