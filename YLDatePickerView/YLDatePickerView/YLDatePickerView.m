//
//  YLDatePickerView.m
//  Driver
//
//  Created by WH on 16/5/9.
//  Copyright © 2016年 WH. All rights reserved.
//

#import "YLDatePickerView.h"

@interface YLDatePickerView()
{
    UIView *backgroundView;
}

@property (nonatomic, strong) UIDatePicker *datePickerView;            // 年月日选择器
@property (nonatomic, strong) UIPickerView *monthPickerView;           // 年月选择器

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;

@end


@implementation YLDatePickerView

-(instancetype)initWithFrame:(CGRect)frame mode:(YLDatePickerViewDateMode)mode title:(NSString *)title cancelButton:(NSString *)cancel otherButton:(NSString *)other {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitle:title cancelButton:cancel otherButton:other];
        
        self.mode = mode;
    }
    return self;
}

#pragma mark - 创建年月日选择器
- (void)creatDatePickerView {
    
    if (!_datePickerView) {
        
        CGRect frame = CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.frame.size.width, self.frame.size.height-_titleLabel.frame.size.height-_cancelButton.frame.size.height);
        
        _datePickerView = [[UIDatePicker alloc] initWithFrame:frame];
        
        [self addSubview:_datePickerView];
    }
}

#pragma mark 创建年月选择器
-(void)creatPickerView {
    
    if (!_monthPickerView) {
        
        if (!_currentDate) {
            _currentDate = [NSDate date];
        }
        
        [self.formatter setDateFormat:@"yyyy"];
        NSString *tempYearString = [self.formatter stringFromDate:_currentDate];
        
        [self.formatter setDateFormat:@"MM"];
        NSString *tempMontyString = [self.formatter stringFromDate:_currentDate];
        
        int selectedYear = [tempYearString intValue];
        int selectedMonth = [tempMontyString intValue];
        
        if (!_yearArray) {
            [self creatYearAndMonthArray];
        }
        
        // 把外部传进来的时间统一转换成内部时间使用，例：2017-01 转成2017年和1月
        _yearString = _yearArray[selectedYear - 1900];
        _monthString = _monthArray[selectedMonth - 1];
        
        CGRect frame = CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.frame.size.width, self.frame.size.height-_titleLabel.frame.size.height-_cancelButton.frame.size.height);
        
        _monthPickerView = [[UIPickerView alloc] initWithFrame:frame];
        [self addSubview:_monthPickerView];
        
        _monthPickerView .delegate = self;
        _monthPickerView.dataSource = self;
        
        [_monthPickerView selectRow:selectedMonth-1 inComponent:1 animated:NO];
        [_monthPickerView selectRow:selectedYear-1900 inComponent:0 animated:NO];
        
        // 设置默认的最大的时间为2099年1月
        NSString *tempYear = [_yearArray lastObject];
        NSString *tempMonth = [_monthArray lastObject];
        
        [self.formatter setDateFormat:@"yyyy-MM"];
        NSString *string = [NSString stringWithFormat:@"%@-%@", [tempYear substringToIndex:tempYear.length-1], [tempMonth substringToIndex:tempMonth.length-1]];
        _maximumDate = [self.formatter dateFromString:string];
    }
}




#pragma mark -
- (void)setTitle:(NSString *)title cancelButton:(NSString *)cancel otherButton:(NSString *)other {
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    UIBezierPath *bMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *bMaskLayer = [[CAShapeLayer alloc] init];
    bMaskLayer.frame = self.bounds;
    bMaskLayer.path = bMaskPath.CGPath;
    self.layer.mask = bMaskLayer;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    _titleLabel.text = title.length ? title :@"日期选择";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    // 指定角导为圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_title.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _title.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _title.layer.mask = maskLayer;
    
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    if (cancel.length) {
        [_cancelButton setTitle:cancel forState:UIControlStateNormal];
    }
    else {
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    
    _cancelButton.tag = 110;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _cancelButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    [_cancelButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okButton addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
    if (other.length) {
        [_okButton setTitle:other forState:UIControlStateNormal];
    }
    else {
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    _okButton.tag = 111;
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_okButton];
    
    // 默认风格
    _titleLabel.backgroundColor = [UIColor orangeColor];
    _okButton.backgroundColor = [UIColor orangeColor];
    
    CGFloat buttonHeight = 45.0;
    CGFloat buttonWidth = self.frame.size.width/2;
    CGFloat buttonY = self.frame.size.height-buttonHeight;
    
    _cancelButton.frame = CGRectMake(0, buttonY, buttonWidth, buttonHeight);
    _okButton.frame = CGRectMake(0 + buttonWidth,  buttonY, buttonWidth, buttonHeight);
    
}

-(NSDateFormatter *)formatter {
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM"];
    }
    
    return _formatter;
}

#pragma mark - set methods
-(void)setCurrentDate:(NSDate *)currentDate {
    
    _currentDate = currentDate;
    _datePickerView.date = _currentDate;
    
    if (_monthPickerView) {

        [self.formatter setDateFormat:@"yyyy"];
        NSString *tempYearString = [self.formatter stringFromDate:_currentDate];
        
        [self.formatter setDateFormat:@"MM"];
        NSString *tempMontyString = [self.formatter stringFromDate:_currentDate];
        
        int selectedYear = [tempYearString intValue];
        int selectedMonth = [tempMontyString intValue];
        
        [_monthPickerView selectRow:selectedYear-1900 inComponent:0 animated:NO];
        [_monthPickerView selectRow:selectedMonth-1 inComponent:1 animated:NO];
        
        if (!_yearArray) {
            [self creatYearAndMonthArray];
        }
        
        // 把外部传进来的时间统一转换成内部时间使用，例：2017-01 转成2017年和1月
        _yearString = _yearArray[selectedYear - 1900];
        _monthString = _monthArray[selectedMonth - 1];
    }
}

-(void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    _datePickerView.minimumDate = _minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    _datePickerView.maximumDate = _maximumDate;
}

- (void)setSkinColor:(UIColor *)skinColor {
    
    _skinColor = skinColor;
    if (_skinColor) {
        _titleLabel.backgroundColor = _skinColor;
        _okButton.backgroundColor = _skinColor;
    }
}

- (void)setMode:(YLDatePickerViewDateMode)mode {
    
    if (mode == YLDatePickerViewDateModeYearAndMonth) {
       
        self.datePickerView.hidden = YES;
        
        if (!self.monthPickerView) {
            [self creatPickerView];
        }
        
        self.monthPickerView.hidden = NO;
        return;
    }
    
    
    self.monthPickerView.hidden = YES;

    if (!self.datePickerView) {
        [self creatDatePickerView];
    }
    
    self.datePickerView.hidden = NO;
    
    switch (mode) {
        case 0:
            self.datePickerView.datePickerMode = UIDatePickerModeTime;
            break;
        case 1:
            self.datePickerView.datePickerMode = UIDatePickerModeDate;
            break;
        case 2:
            self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        default:
            self.datePickerView.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
    }
}


-(void)creatYearAndMonthArray {
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    // 年月选择的时间段，可自行调整
    for (int i = 1900; i < 2100; i++) {
        [_yearArray addObject:[NSString stringWithFormat:@"%i年", i]];
    }
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    for (int i = 1; i <= 12; i++) {
        
        [_monthArray addObject:[NSString stringWithFormat:@"%i月", i]];
    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 35.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {

        return _yearArray.count;
    }
    else {
        return _monthArray.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
    if (component == 0) {
        
        return  _yearArray[row];
    }
    else {
        return  _monthArray[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 比较一下选择的时间是否有超出最大时间限制
    [self.formatter setDateFormat:@"yyyy"];
    NSString *maxYearString = [self.formatter stringFromDate:_maximumDate];
    int maxYear = [maxYearString intValue];
    
    [self.formatter setDateFormat:@"MM"];
    NSString *maxMonthString = [self.formatter stringFromDate:_maximumDate];
    int maxMonth = [maxMonthString intValue];
    
    
    NSString *tempYearString = _yearArray[[pickerView selectedRowInComponent:0]];
    int selectedYear = [tempYearString intValue];

    NSString *tempMonthString = _monthArray[[pickerView selectedRowInComponent:1]];
    int selectedMonth = [tempMonthString intValue];
    

    if (selectedYear > maxYear) {
        
        [pickerView selectRow:maxYear-1900 inComponent:0 animated:YES];
        [pickerView selectRow:maxMonth-1 inComponent:1 animated:YES];
        return;
    }
    
    if (selectedYear == maxYear) {
        
        if (selectedMonth > maxMonth) {
            [pickerView selectRow:maxYear-1900 inComponent:0 animated:YES];
            [pickerView selectRow:maxMonth-1 inComponent:1 animated:YES];
            return;
        }
    }

    
    if (component == 0) {
        _yearString = _yearArray[row];
    }
    else {
        _monthString = _monthArray[row];
    }
}


#pragma mark - 点击确定回调
-(void)selectbtn:(UIButton *)button {
    
    if (button.tag == 110) {
        [self hide];
    }
    else {
        [self hide];
        
        if (_datePickerView) {
            [self.delegate datePickerClickButtonAtIndex:button.tag date:_datePickerView.date];
            return;
        }
        
        if (_monthPickerView) {
            
            [self.formatter setDateFormat:@"yyyy-MM"];
            
            // 2017年 -> 2017
            NSString *tempYearString = [_yearString substringToIndex:_yearString.length-1];
           
            // 1月  -> 1
            NSString *tempMonthString = [_monthString substringToIndex:_monthString.length-1];
            
            NSString *dateString = [NSString stringWithFormat:@"%@-%@", tempYearString, tempMonthString];
            NSDate *date = [self.formatter dateFromString:dateString];
            [self.delegate datePickerClickButtonAtIndex:button.tag date:date];
        }
    }
}

#pragma mark - 显示\隐藏
-(void)show{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (!backgroundView) {
        backgroundView = [[UIView alloc] initWithFrame:keyWindow.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
    }
    
    backgroundView.alpha = 0.3;
    [keyWindow addSubview:backgroundView];
    
    self.alpha = 1;
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
}

-(void)hide {
    
    __block typeof(self)selfWeak = self;
    
    [UIView animateWithDuration:0.15 animations:^{
       
        selfWeak.transform = CGAffineTransformConcat(selfWeak.transform, CGAffineTransformMakeScale(0.01, 0.01));
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [backgroundView removeFromSuperview];
            [selfWeak removeFromSuperview];
            
            // 从父视图移除后，恢复原来大小,等待下一次展示
            selfWeak.transform = CGAffineTransformConcat(selfWeak.transform, CGAffineTransformMakeScale(100, 100));
        }
    }];
}



@end
