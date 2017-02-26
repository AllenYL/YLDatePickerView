//
//  ViewController.m
//  YLDatePickerView
//
//  Created by 公爵 on 2017/2/26.
//  Copyright © 2017年 公爵. All rights reserved.
//

#import "ViewController.h"

#import "YLDatePickerView.h"

@interface ViewController ()<YLDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSDateFormatter *)formatter {
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        
        // 随便用的格式，转化为字符串时请根据实际需求控制
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return _formatter;
}


- (IBAction)showDatePicker:(UIButton *)sender {
    
    [self clear];
    
    NSInteger mode = sender.tag - 110;
    
    YLDatePickerView *date = [[YLDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 290) mode:mode title:@"日期" cancelButton:nil otherButton:nil];
    
    date.center = self.view.center;
    
    date.delegate = self;
    
    date.currentDate = [self.formatter dateFromString:@"1900-07-09 23:59:59"];
    date.maximumDate = [NSDate date];
    
    [self.view addSubview:date];
    
    [date show];
}


-(void)clear {
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[YLDatePickerView class]]) {
            [obj removeFromSuperview];
            obj = nil;
            *stop = YES;
        }
    }];
}

#pragma mark - YLDatePickerViewDelegate
-(void)datePickerClickButtonAtIndex:(NSInteger)index date:(NSDate *)chooseDate {
    
    if (index) {
        _label.text = [self.formatter stringFromDate:chooseDate];
    }
}

@end
