//
//  SKYDeveloperViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/2/14.
//  Copyright (c) 2014 Sky Apps. All rights reserved.
//

#import "SKYDeveloperViewController.h"

@interface SKYDeveloperViewController ()

@end

@implementation SKYDeveloperViewController

@synthesize delegate = _delegate;

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
    UIAlertView *feedBackAlert = [[UIAlertView alloc] initWithTitle:@"Do you love MovieMood?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Absolutely", @"Not Quite", nil];
    [feedBackAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        //TODO: Send to app store
    }
    else {
        [_delegate dislikePressed];
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
