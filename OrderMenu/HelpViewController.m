//
//  HelpViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-8.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize pageC;
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
    self.view.backgroundColor=[UIColor clearColor];
    self.navigationController.navigationBar.hidden=YES;
   // [[UIApplication sharedApplication]setStatusBarHidden:YES];
    UIScrollView *helpScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, 320, [UIScreen mainScreen].bounds.size.height)];
    helpScroll.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.7];
    [self.view addSubview:helpScroll];
    helpScroll.pagingEnabled=YES;
    helpScroll.showsHorizontalScrollIndicator=NO;
    helpScroll.delegate=self;
    helpScroll.contentSize=CGSizeMake(320*5, 132);
    for (int i = 0 ; i<4; i++) {
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        aImage.userInteractionEnabled = YES;
        //         aImage.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:212.0/255.0 blue:217.0/255.0 alpha:1];
        aImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"help%d",i+1]];
        [helpScroll addSubview:aImage];
        
    }
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(120,[UIScreen mainScreen].bounds.size.height-70, 100, 10)];
    pageC.numberOfPages = 4;
    pageC.currentPage=0;
    [self.view addSubview:pageC];
}
#pragma mark UIScrollViewDelegate Methods
int helpfileHidden = 0;
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageHight = scrollView.frame.size.width;
    currentHelppage = floor((scrollView.contentOffset.x - pageHight / 2) / pageHight) + 1;
    
    //    //NSLog(@"currentpage    %i",currentHelppage);
    if (currentHelppage == 2) {
        helpfileHidden = 0;
    }
    if (currentHelppage >= 3) {
        //         //NSLog(@"[helpData count]    %i",[helpData count]);
        if (helpfileHidden) {
            //            BooksStoreAppDelegate * mainDelegate = (BooksStoreAppDelegate *)[[UIApplication sharedApplication]delegate];
            //            [mainDelegate HelpOutAction];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"helpFileVC" object:nil];
           [self.navigationController popViewControllerAnimated:YES];
//            [self.view removeFromSuperview];
            pageC.hidden=YES;
        }
        helpfileHidden = 1;
    }
    if (currentHelppage<5) {
        self.pageC.currentPage = currentHelppage;
    }
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

        int page2=scrollView.contentOffset.x/320;
        self.pageC.currentPage=page2;


}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
