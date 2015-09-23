//
//  LSWTestAViewController.m
//  LSWCustomTabBarController
//
//  Created by sWen on 15/9/22.
//  Copyright (c) 2015年 sWen. All rights reserved.
//

#import "LSWTestAViewController.h"
#import "LSWTestADetailViewController.h"

@interface LSWTestAViewController ()

@property (nonatomic, weak) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonAction:(id)sender;

@end

@implementation LSWTestAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TestA";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Action

- (IBAction)nextButtonAction:(id)sender {
    LSWTestADetailViewController *testADetailVC = [[LSWTestADetailViewController alloc] init];
    [self.navigationController pushViewController:testADetailVC animated:YES];
}

@end
