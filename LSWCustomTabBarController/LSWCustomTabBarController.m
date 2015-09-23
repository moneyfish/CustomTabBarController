//
//  LSWCustomTabBarController.m
//  LSWCustomTabBarController
//
//  Created by sWen on 15/9/23.
//  Copyright (c) 2015年 sWen. All rights reserved.
//

#import "LSWCustomTabBarController.h"
#import "LSWTestAViewController.h"
#import "LSWTestBViewController.h"
#import <Masonry.h>
#import "UIImage+UIColor.h"

// 获取RGB颜色
#define ColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ColorRGB(r,g,b) ColorRGBA(r,g,b,1.0f)

//TabBarButtonTag
#define kTabBarButtonTagBase  10000

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

@interface LSWCustomTabBarController () <UINavigationControllerDelegate> {
    UIView *_tabBarView;//自定义的tabBar
    MASConstraint *_tabBarBottomConstraint;//tabBar的底部约束
}

@end

@implementation LSWCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewController];
    [self setCustomTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化控制器
 */
- (void)setViewController{
    LSWTestAViewController *testAVC = [[LSWTestAViewController alloc] init];
    LSWTestBViewController *testBVC = [[LSWTestBViewController alloc] init];
    
    NSArray *viewArray = @[testAVC, testBVC];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:viewArray.count];
    for (int i = 0; i < viewArray.count; i++) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewArray[i]];
        [viewControllers addObject:navigation];
        navigation.delegate = self;
    }
    self.viewControllers = viewControllers;
}

/**
 *  初始化自定义的TabBar
 */
- (void)setCustomTabBar{
    [self.tabBar setHidden:YES];
    
    UIImage *tabBarBgImg = [UIImage imageWithColor:ColorRGBA(57.0, 57.0, 57.0, 0.8)];
    _tabBarView                 = [[UIView alloc] init];
    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:tabBarBgImg] ;
    [self.view addSubview:_tabBarView];
    
    [_tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        _tabBarBottomConstraint = make.bottom.equalTo(@0);
        make.height.equalTo(@(self.tabBar.frame.size.height));
    }];
    
    NSArray *btnTitleArray = @[
         @"TestA",
         @"TestB"
    ];
    NSArray *backgroundArray = @[
         [UIImage imageWithColor:[UIColor orangeColor]],
         [UIImage imageWithColor:[UIColor blueColor]]
    ];
    NSArray *bgHighlightedArray = @[
         [UIImage imageWithColor:[UIColor whiteColor]],
         [UIImage imageWithColor:[UIColor whiteColor]]
    ];
    
    //前面一个button
    UIView *frontButton = nil;
    for (NSInteger i = 0; (i < backgroundArray.count && (backgroundArray.count == bgHighlightedArray.count) && (backgroundArray.count == btnTitleArray.count)); i++) {
        UIButton *button      = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = i == 0 ? NO : YES;
        button.selected       = i == 0 ? YES : NO;
        button.tag            = i + kTabBarButtonTagBase;
        [button setBackgroundImage:backgroundArray[i] forState:UIControlStateNormal];
        [button setBackgroundImage:bgHighlightedArray[i] forState:UIControlStateSelected];
        [button setBackgroundImage:bgHighlightedArray[i] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(selectedTab:)
         forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:button];
        
        /**
         *  masonry定义右边约束和底部约束时，‘负数’表示‘子视图’在‘父视图’里面，‘正数’表示‘子视图’在‘父视图’外面，这点需要注意
         */
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (frontButton) {
                make.left.equalTo(frontButton.mas_right);
            }else{
                make.left.equalTo(@0);
            }
            make.top.equalTo(@3);
            make.bottom.equalTo(@-3);
            make.width.equalTo(@(self.view.frame.size.width/backgroundArray.count));
        }];
        frontButton = button;
    }
    
}

#pragma mark - tabBar效果切换

/**
 *  tab 按钮的点击事件
 *
 *  @param button <#button description#>
 */
- (void)selectedTab:(UIButton *)button {
    //切换viewController
    self.selectedIndex = button.tag - kTabBarButtonTagBase;
    //更新tabBarView中的button
    button.userInteractionEnabled = NO;
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIButton *tabButton =(UIButton *) [_tabBarView viewWithTag:i + kTabBarButtonTagBase];
        if (button.tag != i + kTabBarButtonTagBase) {
            tabButton.selected = NO;
            tabButton.userInteractionEnabled = YES;
        }else{
            button.selected = YES;
        }
    }
}

#pragma mark - UINavigationCtroller delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    /**
     *  是否显示tabbar
     *  修改约束值
     *  masonry定义右边约束和底部约束时，‘负数’表示‘子视图’在‘父视图’里面，‘正数’表示‘子视图’在‘父视图’外面，这点需要注意
     */
    NSUInteger count = navigationController.viewControllers.count;
    if (count > 1) {
         _tabBarBottomConstraint.offset = _tabBarView.frame.size.height;
    }else{
        _tabBarBottomConstraint.offset = 0;
    }
    //动画
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
