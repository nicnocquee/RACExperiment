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
- (id)loginWithEmail:(NSString *)email password:(NSString *)password;

@property (nonatomic, assign) BOOL loggingIn;

@end
