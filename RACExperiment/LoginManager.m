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
@property (nonatomic, weak) id<RACSubscriber> signalSubscriber;

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

- (id)loginWithEmail:(NSString *)email password:(NSString *)password {
    //experiment
    self.loggingIn = YES;
    self.email = email;
    self.password = password;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.signalSubscriber = subscriber;
        return nil;
    }];
    [self performSelector:@selector(login) withObject:nil afterDelay:2];
    return signal;
}

- (void)login {
    if ((arc4random()%2) == 0) {
        self.loggingIn = NO;
        [self.signalSubscriber sendError:[NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Error contacting server", nil)}]];
    } else {
        self.loggingIn = NO;
        [self.signalSubscriber sendCompleted];
    }
}

@end
