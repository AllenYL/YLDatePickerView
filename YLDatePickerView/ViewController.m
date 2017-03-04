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

@property (nonatomic, strong) YLDatePickerView *datePickerView;

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


-(YLDatePickerView *)datePickerView {
    
    if (!_datePickerView) {
        
        _datePickerView = [[YLDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 290) mode:0 title:@"日期" cancelButton:nil otherButton:nil];
        
        _datePickerView.center = self.view.center;
        
        _datePickerView.delegate = self;
        
        _datePickerView.currentDate = [self.formatter dateFromString:@"1900-01-01 00:00:00"];
        _datePickerView.maximumDate = [NSDate date];
        
        [self.view addSubview:_datePickerView];
    }
    
    return _datePickerView;
}

- (IBAction)showDatePicker:(UIButton *)sender {
    
    NSInteger mode = sender.tag - 110;
    self.datePickerView.mode = mode;
    
    [self.datePickerView show];
}


#pragma mark - YLDatePickerViewDelegate
-(void)datePickerClickButtonAtIndex:(NSInteger)index date:(NSDate *)chooseDate {
    
    if (index) {
        _label.text = [self.formatter stringFromDate:chooseDate];
    }
}

@end
