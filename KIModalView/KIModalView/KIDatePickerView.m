//
//  KIDatePickerView.m
//  Kitalker
//
//  Created by Kitalker on 14/9/26.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIDatePickerView.h"

@interface KIDatePickerView () {
    UIDatePicker *_pickerView;
}

@property (nonatomic, copy) KIDatePickerViewDidUpdateDateBlock  didUpdateDateBlock;
@property (nonatomic, copy) KIDatePickerViewDidDismissBlock     pickerViewDidDismissBlock;
@end

@implementation KIDatePickerView

#pragma mark - Lifecycle
- (void)dealloc {
    _pickerView = nil;
    _didUpdateDateBlock = nil;
    _pickerViewDidDismissBlock = nil;
}

#pragma mark - Methods
- (void)didUpdateDateAction:(UIDatePicker *)sender {
    [self didUpdateDate:sender.date];
}

- (void)didUpdateDate:(NSDate *)date {
    if (self.didUpdateDateBlock != nil) {
        __weak KIDatePickerView *weakSelf = self;
        self.didUpdateDateBlock(weakSelf, date);
    }
}

- (void)cancel {
    [self dismissWithTag:KIModalViewDismissWithCancelTag didSelectedDate:nil];
}

- (void)confirm {
    [self dismissWithTag:KIModalViewDismissWithConfirmTag didSelectedDate:self.pickerView.date];
}

- (void)dismissWithTag:(int)tag didSelectedDate:(NSDate *)date {
    [self dismissWithTag:tag userInfo:date];
    if (_pickerViewDidDismissBlock != nil) {
        __weak KIDatePickerView *weakSelf = self;
        self.pickerViewDidDismissBlock(weakSelf, tag, date);
    }
}

#pragma mark - Getters and setters
- (UIDatePicker *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIDatePicker alloc] init];
        [_pickerView setFrame:CGRectMake(0,
                                         self.heightForToolbar,
                                         self.widthForWindow,
                                         self.heightForPickerView)];
        [_pickerView addTarget:self
                        action:@selector(didUpdateDateAction:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _pickerView;
}

- (UIDatePickerMode)datePickerMode {
    return self.pickerView.datePickerMode;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    [self.pickerView setDatePickerMode:datePickerMode];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    [self.pickerView setDate:date animated:animated];
}

- (void)setDidUpdateDateBlock:(KIDatePickerViewDidUpdateDateBlock)block {
    _didUpdateDateBlock = [block copy];
}

- (void)setPickerViewDidDismissBlock:(KIDatePickerViewDidDismissBlock)block {
    _pickerViewDidDismissBlock = [block copy];
}

@end
