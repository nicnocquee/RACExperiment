//
//  LoginManager.h
//  RACExperiment
//
//  Created by Nico Prananta on 4/7/13.
//  Copyright (c) 2013 Appsccelerated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (LoginManager *)sharedManager;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password;

@property (nonatomic, assign) BOOL loggingIn;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, strong) NSError *error;



@end
