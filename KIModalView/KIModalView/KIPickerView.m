//
//  KIPickerView.m
//  Kitalker
//
//  Created by Kitalker on 14-5-13.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIPickerView.h"

@interface KIPickerView () {
    UIPickerView    *_pickerView;
}

@property (nonatomic, copy) KIPickerViewDidDismissBlock                 pickerViewDidDismissBlock;

@property (nonatomic, copy) KIPickerViewNumberOfComponentsBlock         numberOfComponentsBlock;
@property (nonatomic, copy) KIPickerViewNumberOfRowsInComponentBlock    numberOfRowsInComponentBlock;
@property (nonatomic, copy) KIPickerViewWidthForComponentBlock          widthForComponentBlock;
@property (nonatomic, copy) KIPickerViewTitleForRowInComponentBlock     titleForRowInComponentBlock;
@property (nonatomic, copy) KIPickerViewViewForRowInComponentBlock      viewForRowInComponentBlock;
@property (nonatomic, copy) KIPickerViewDidSelectRowInComponentBlock    didSelectRowInComponentBlock;

@end

@implementation KIPickerView

#pragma mark - Lifecycle
- (void)dealloc {
    _pickerView = nil;
    
    _dataSource = nil;
    _keyPathForTitle = nil;
    _prefix = nil;
    _suffix = nil;
    
    _pickerViewDidDismissBlock = nil;
    
    _numberOfComponentsBlock = nil;
    _numberOfRowsInComponentBlock = nil;
    _widthForComponentBlock = nil;
    _viewForRowInComponentBlock = nil;
    _titleForRowInComponentBlock = nil;
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataSource != nil) {
        return 1;
    } else if (self.numberOfComponentsBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        NSInteger components = self.numberOfComponentsBlock(weakSelf);
        return components;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource != nil) {
        return self.dataSource.count;
    } else if (self.numberOfRowsInComponentBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        return self.numberOfRowsInComponentBlock(weakSelf, component);
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.dataSource != nil) {
        id item = self.dataSource[row];
        NSString *title = @"";
        if ([item isKindOfClass:[NSString class]]) {
            title = item;
        } else if ([item isKindOfClass:[NSNumber class]]) {
            title = [item stringValue];
        } else {
            if (self.keyPathForTitle) {
                title = [item valueForKeyPath:self.keyPathForTitle];
            } else {
                title = [item description];
            }
        }
        
        if (self.prefix != nil) {
            title = [NSString stringWithFormat:@"%@%@", self.prefix, title];
        }
        
        if (self.suffix != nil) {
            title = [NSString stringWithFormat:@"%@%@", title, self.suffix];
        }
        
        return title;
    } else if (self.titleForRowInComponentBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        return self.titleForRowInComponentBlock(weakSelf, row, component);
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat width = 294.0f;
    if (systemVersion >= 7.0) {
        width = self.widthForWindow;
    }
    NSInteger numberOfComponents = [self numberOfComponentsInPickerView:pickerView];
    
    width = width / numberOfComponents;
    
    if (self.widthForComponentBlock != nil) {
        width = self.widthForComponentBlock(self, component);
    }
    
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat height = 36.0f;
    if (systemVersion >= 7.0) {
        height = 30.0f;
    }
    return height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (self.viewForRowInComponentBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        self.viewForRowInComponentBlock(weakSelf, row, component, view);
    } else {
        UILabel *label = (UILabel *)view;
        if (label == nil || ![label isKindOfClass:[UILabel class]]) {
            CGSize rowSize = [pickerView rowSizeForComponent:component];
            CGFloat x = (CGRectGetWidth(pickerView.frame) - rowSize.width) / 2;
            label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, rowSize.width, rowSize.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:22.0f]];
            [label setTextColor:[UIColor darkTextColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
        }
        
        NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
        [label setText:title];
        
        return label;
    }
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_didSelectRowInComponentBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        self.didSelectRowInComponentBlock(weakSelf, row, component);
    }
}

#pragma mark - Methods
- (void)cancel {
    [self dismissWithTag:KIModalViewDismissWithCancelTag selectedRow:-1 userInfo:nil];
}

- (void)confirm {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    
    id selctedItem = nil;
    if (self.dataSource != nil && self.dataSource.count > 0) {
        selctedItem = [self.dataSource objectAtIndex:row];
    }
    
    [self dismissWithTag:KIModalViewDismissWithConfirmTag selectedRow:row userInfo:selctedItem];
}

- (void)dismissWithTag:(int)tag selectedRow:(NSInteger)row userInfo:(id)userInfo {
    [self dismissWithTag:tag userInfo:userInfo];
    if (self.pickerViewDidDismissBlock != nil) {
        __weak KIPickerView *weakSelf = self;
        self.pickerViewDidDismissBlock(weakSelf, tag, row, userInfo);
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    NSInteger index = row;
    NSInteger maxRow = [self pickerView:self.pickerView numberOfRowsInComponent:component];
    
    if (index > maxRow) {
        index = maxRow - 1;
    }
    
    [self.pickerView selectRow:index inComponent:component animated:animated];
    
}

#pragma mark - Getters and setters
- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setShowsSelectionIndicator:YES];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setFrame:CGRectMake(0,
                                         self.heightForToolbar,
                                         self.widthForWindow,
                                         self.heightForPickerView)];
    }
    return _pickerView;
}


- (void)setPickerViewDidDismissBlock:(KIPickerViewDidDismissBlock)block {
    _pickerViewDidDismissBlock = [block copy];
}

- (void)setNumberOfComponentsBlock:(KIPickerViewNumberOfComponentsBlock)block {
    _numberOfComponentsBlock = [block copy];
}

- (void)setNumberOfRowsInComponentBlock:(KIPickerViewNumberOfRowsInComponentBlock)block {
    _numberOfRowsInComponentBlock = [block copy];
}

- (void)setWidthForComponentBlock:(KIPickerViewWidthForComponentBlock)block {
    _widthForComponentBlock = [block copy];
}

- (void)setTitleForRowInComponentBlock:(KIPickerViewTitleForRowInComponentBlock)block {
    _titleForRowInComponentBlock = [block copy];
}

- (void)setViewForRowInComponentBlock:(KIPickerViewViewForRowInComponentBlock)block {
    _viewForRowInComponentBlock = [block copy];
}

- (void)setDidSelectRowInComponentBlock:(KIPickerViewDidSelectRowInComponentBlock)block {
    _didSelectRowInComponentBlock = [block copy];
}

@end
