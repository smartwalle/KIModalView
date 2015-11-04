//
//  KIDatePickerView.h
//  Kitalker
//
//  Created by Kitalker on 14/9/26.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIBasePickerView.h"

@class KIDatePickerView;
typedef void(^KIDatePickerViewDidUpdateDateBlock)   (KIDatePickerView *pickerView, NSDate *date);
typedef void(^KIDatePickerViewDidDismissBlock)      (KIDatePickerView *pickerView, int tag, NSDate *date);

@interface KIDatePickerView : KIBasePickerView

@property (nonatomic, readonly) UIDatePicker    *pickerView;
@property (nonatomic) UIDatePickerMode          datePickerMode;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setDidUpdateDateBlock:(KIDatePickerViewDidUpdateDateBlock)block;
- (void)setPickerViewDidDismissBlock:(KIDatePickerViewDidDismissBlock)block;

@end
