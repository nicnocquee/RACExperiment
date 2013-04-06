//
//  ViewController.m
//  RACExperiment
//
//  Created by Nico Prananta on 4/7/13.
//  Copyright (c) 2013 Appsccelerated. All rights reserved.
//

#import "ViewController.h"
#import "LoginManager.h"
#import "NSString+Validation.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupFormValiditySignal];
    [self setupButtonColorRelationship];
    [self setupSignInButtonAction];
    [self setupActivityViewRelationship];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setups

- (void)setupActivityViewRelationship {
    @weakify(self);
    [RACAble([LoginManager sharedManager], loggingIn) subscribeNext:^(NSNumber *loggingIn) {
        @strongify(self);
        (loggingIn.boolValue)?[self.activityView startAnimating]:[self.activityView stopAnimating];
    }];
}

- (void)setupFormValiditySignal {    
    RACSignal *formValid = [RACSignal combineLatest:@[
                            self.email.rac_textSignal,
                            self.password.rac_textSignal,
                            RACAbleWithStart([LoginManager sharedManager], loggingIn)
                            ] reduce:^(NSString *email, NSString *password, NSNumber *loggingIn){
                                return @(email.length > 0 && [email isValidEmailAddress] && password.length > 0 && !loggingIn.boolValue);
                            }];
    RAC(self.signinButton.enabled) = formValid;
}

- (void)setupButtonColorRelationship {
    RACSignal *fieldTextColor = [RACAbleWithStart(self.signinButton.enabled) map:^UIColor*(NSNumber *enabled) {
        return (enabled.boolValue)?[UIColor blueColor]:[UIColor grayColor];
    }];
    RAC(self.signinButton.backgroundColor) = fieldTextColor;
    
    [[self.signinButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        self.signinButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.004 blue:0.710 alpha:1.000];
    }];
}

- (void)setupSignInButtonAction {
    @weakify(self);
    
    [[self.signinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self initiateLogin];
    }];
}

- (void)presentError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                          otherButtonTitles: nil];
    [alert show];
    
}

- (void)presentSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                    message:NSLocalizedString(@"Successfully signing in!", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                          otherButtonTitles: nil];
    [alert show];
    
}

- (void)initiateLogin {
    @weakify(self);
    RACSignal *loginSignal = [[LoginManager sharedManager]
                              loginWithEmail:self.email.text
                              password:self.password.text
                              ];
    [loginSignal subscribeError:^(NSError *error) {
        @strongify(self);
        [self presentError:error];
    } completed:^{
        @strongify(self);
        [self presentSuccess];
    }];
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.email) {
        [self.password becomeFirstResponder];
    } else {
        [self initiateLogin];
    }
    return YES;
}

@end
