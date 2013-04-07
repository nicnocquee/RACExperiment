//
//  LoginManager.m
//  RACExperiment
//
//  Created by Nico Prananta on 4/7/13.
//  Copyright (c) 2013 Appsccelerated. All rights reserved.
//

#import "LoginManager.h"

@interface LoginManager ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

@end

@implementation LoginManager

+ (LoginManager *)sharedManager {
    static LoginManager *loginManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginManager = [[LoginManager alloc] init];
    });
    return loginManager;
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
    //experiment
    self.loggingIn = YES;
    self.email = email;
    self.password = password;
    
    [self performSelector:@selector(login) withObject:nil afterDelay:2];
}

- (void)login {
    if ((arc4random()%2) == 0) {
        self.error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Request Time Out", nil)}];
        self.loggingIn = NO;
        self.loggedIn = NO;
        
    } else {
        self.error = nil;
        self.loggingIn = NO;
        self.loggedIn = YES;
    }
}

@end
