//
//  TJDataSetClient.h
//  TJDataSetClient
//
//  Created by 王朋涛 on 16/8/31.
//  Copyright © 2016年 王朋涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIScrollView+EmptyDataSet.h>

typedef NS_ENUM(NSInteger, DataSetState)
{
    DataSetLoading,//网络加载
    DataSetFailureLoad,//网络返回失败 code
    DataSetNoData,//网络加载无数据
    DataSetNetWorkingError,//网络请求错误
    DataSetEmptyView//空白页
};
@interface TJDataSetClient : NSObject<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) DataSetState state;
@property (nonatomic, copy) void (^reloading)();
@property (nonatomic, copy) NSString *respondString;     //自定义的加载结果提示语
@property (nonatomic, assign) BOOL isNotShowPrompting;          //是否显示加载中的等待提醒
@property (nonatomic, strong) UIImage *emptyDefaultImage;    //自定义无数据时的默认图片
@property (nonatomic, assign) CGFloat verticalOff; //向上偏移
-(instancetype)initWithSuperScrollView:(UIScrollView*)sv;

@end
