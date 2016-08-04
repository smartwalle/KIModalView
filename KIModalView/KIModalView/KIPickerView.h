//
//  KIPickerView.h
//  Kitalker
//
//  Created by Kitalker on 14-5-13.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIBasePickerView.h"

@class KIPickerView;
typedef NSInteger(^KIPickerViewNumberOfComponentsBlock)         (KIPickerView *pickerView);
typedef NSInteger(^KIPickerViewNumberOfRowsInComponentBlock)    (KIPickerView *pickerView, NSInteger component);
typedef CGFloat (^KIPickerViewWidthForComponentBlock)           (KIPickerView *pickerView, NSInteger component);
typedef NSString *(^KIPickerViewTitleForRowInComponentBlock)    (KIPickerView *pickerView, NSInteger row, NSInteger component);
typedef UIView *(^KIPickerViewViewForRowInComponentBlock)       (KIPickerView *pickerView, NSInteger row, NSInteger component, UIView *reusingView);
typedef void(^KIPickerViewDidSelectRowInComponentBlock)         (KIPickerView *pickerView, NSInteger row, NSInteger component);

typedef void(^KIPickerViewDidDismissBlock)   (KIPickerView *view, int tag, NSInteger selectedRow, id userInfo);

@interface KIPickerView : KIBasePickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readonly) UIPickerView    *pickerView;

//dataSource 和 block 二选一，如果同时设置了两者，将优先选择dataSource, dataSource用于简单的pickerView,只能有一个component
@property (nonatomic, strong) NSArray   *dataSource;
//用于dataSource里面的数据为特殊对象类型，可以通过这个keypath显示titleForRow
@property (nonatomic, copy) NSString  *keyPathForTitle;
@property (nonatomic, copy) NSString  *prefix;
@property (nonatomic, copy) NSString  *suffix;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)setPickerViewDidDismissBlock:(KIPickerViewDidDismissBlock)block;

- (void)setNumberOfComponentsBlock:(KIPickerViewNumberOfComponentsBlock)block;
- (void)setNumberOfRowsInComponentBlock:(KIPickerViewNumberOfRowsInComponentBlock)block;
- (void)setWidthForComponentBlock:(KIPickerViewWidthForComponentBlock)block;
- (void)setTitleForRowInComponentBlock:(KIPickerViewTitleForRowInComponentBlock)block;
- (void)setViewForRowInComponentBlock:(KIPickerViewViewForRowInComponentBlock)block;
- (void)setDidSelectRowInComponentBlock:(KIPickerViewDidSelectRowInComponentBlock)block;

@end
