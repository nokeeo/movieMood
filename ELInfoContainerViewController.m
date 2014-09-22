//
//  SKYInfoContainerViewController.m
//  MovieMood
//
//  Created by Eric Lee on 5/3/14.
//  Copyright (c) 2014 Eric Lee Productions. All rights reserved.
//

#import "ELInfoContainerViewController.h"
#import "ELInfoViewController.h"

@interface ELInfoContainerViewController ()

@property (nonatomic, retain) MFMailComposeViewController *mailVC;
@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) SKStoreProductViewController *appStoreVC;
@property (nonatomic, retain) ELInfoViewController *infoPage;
@end

@implementation ELInfoContainerViewController

@synthesize emailAddress = _emailAddress;
@synthesize mailVC = _mailVC;
@synthesize appStoreVC = _appStoreVC;

-(void) awakeFromNib {
    [super awakeFromNib];
     _infoPage = [[ELInfoViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];

    ELDeveloperViewController *developerPage = [[ELDeveloperViewController alloc] initWithNibName:@"DevelopersView" bundle:nil];
    developerPage.parentVC = self;
    [viewControllers addObject: developerPage];
    [_infoPage setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [viewControllers addObject:[[UIViewController alloc] initWithNibName:@"ImageCredits" bundle:nil]];
    
    _infoPage.data = viewControllers;
    
    [self.view addSubview: _infoPage.view];
}

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
    _emailAddress = @"feedback@moviemoodapp.com";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)appStorePressed {
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if(!error)
        [_mailVC dismissViewControllerAnimated:YES completion:nil];
    else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"We were not able to send your message please try again."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        [errorAlert show];
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
