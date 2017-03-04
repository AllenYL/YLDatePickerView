//
//  YLDatePickerView.h
//  Driver
//
//  Created by WH on 16/5/9.
//  Copyright © 2016年 WH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YLDatePickerViewDateMode) {
    
    YLDatePickerViewDateModeTime,
    YLDatePickerViewDateModeDate,
    YLDatePickerViewDateModeDateAndTime,
    YLDatePickerViewDateModeCountDownTimer,
    YLDatePickerViewDateModeYearAndMonth,
};

@protocol YLDatePickerViewDelegate <NSObject>

- (void)datePickerClickButtonAtIndex:(NSInteger)index date:(NSDate *)chooseDate;

@end

/**
 *  日期选择器
 */
@interface YLDatePickerView : UIImageView<UIPickerViewDataSource, UIPickerViewDelegate,CAAnimationDelegate>

/**
 *  时间选择器的标题
 */
@property(nonatomic,strong)UILabel *titleLabel;

/**
 *  取消按钮
 */
@property(nonatomic,strong)UIButton *cancelButton;

/**
 *  确定按钮
 */
@property(nonatomic,strong)UIButton *okButton;

/**
 *  调出时间选择器时要显示的时间
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 *  日期选择器最小时间
 */
@property (nonatomic, strong) NSDate *minimumDate;

/**
 *  日期选择器最大时间
 */
@property (nonatomic, strong) NSDate *maximumDate;

/**
 *  时间选择器的颜色风格
 */
@property (nonatomic, strong) UIColor *skinColor;

/**
 *  日期选择类型
 */
@property (nonatomic, assign) YLDatePickerViewDateMode mode;

/**
 *  时间选择器的代理
 */
@property (nonatomic, assign) id<YLDatePickerViewDelegate>delegate;

@property (nonatomic, assign) BOOL pickerViewScrolling;


/*
 *  初始化
 */
-(instancetype)initWithFrame:(CGRect)frame mode:(YLDatePickerViewDateMode)mode title:(NSString *)title cancelButton:(NSString *)cancel otherButton:(NSString *)other;

/**
 *  第一种show出的方式
 */
-(void)show;

/**
 *  隐藏
 */
-(void)hide;

@end
