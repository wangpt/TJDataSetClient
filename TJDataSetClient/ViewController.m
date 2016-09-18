//
//  ViewController.m
//  TJDataSetClient
//
//  Created by 王朋涛 on 16/9/5.
//  Copyright © 2016年 王朋涛. All rights reserved.
//

#import "ViewController.h"
#import "TJDataSetClient.h"
@interface ViewController ()
@property (nonatomic,strong) TJDataSetClient *emptyDataSet;

@end
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WeakSelf __weak typeof(self) weakSelf = self;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   UIScrollView * _emptyView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_emptyView];
    self.emptyDataSet = [[TJDataSetClient alloc]initWithSuperScrollView:_emptyView];
    self.emptyDataSet.verticalOff= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+ CGRectGetHeight(self.navigationController.navigationBar.frame);
    WeakSelf;
    self.emptyDataSet.reloading = ^{

        [weakSelf loadData];
    };
    [weakSelf loadData];

}

- (void)loadData{
    self.view.userInteractionEnabled=NO;
    self.emptyDataSet.state = DataSetLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.view.userInteractionEnabled=YES;
        self.emptyDataSet.state = DataSetFailureLoad;

    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
