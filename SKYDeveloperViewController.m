//
//  SKYDeveloperViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYDeveloperViewController.h"

@interface SKYDeveloperViewController ()

@property (nonatomic, retain) UIAlertView *appFeelingAlert;
@property (nonatomic, retain) UIAlertView *reviewAlert;

@end

@implementation SKYDeveloperViewController

@synthesize delegate = _delegate;
@synthesize appFeelingAlert = _appFeelingAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackPressed:(id)sender {
    _appFeelingAlert = [[UIAlertView alloc] initWithTitle:@"Do you love MovieMood?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Absolutely", @"Not Quite", nil];
    [_appFeelingAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0 && [alertView  isEqual: _appFeelingAlert]) {
        _reviewAlert = [[UIAlertView alloc] initWithTitle:@"Thats Great!" message:@"We'd really appreciate it if you rate our app" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Sure", @"Maybe Later", nil];
        [_reviewAlert show];
    }
    else if(buttonIndex == 1 && [alertView isEqual: _appFeelingAlert]){
        [_delegate dislikePressed];
    }
    
    else if(buttonIndex == 0 && [_reviewAlert isEqual: alertView]) {
        [_delegate appStorePressed];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
