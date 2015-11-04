//
//  KIBasePickerView.h
//  Kitalker
//
//  Created by Kitalker on 14/9/26.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIModalView.h"

@interface KIBasePickerView : KIModalView

@property (nonatomic, readonly) UILabel         *titleLabel;
@property (nonatomic, readonly) UIToolbar       *toolbar;
@property (nonatomic, copy) NSString            *title;

@property (nonatomic, readonly) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *confirmButtonItem;

@property (nonatomic, readonly) CGFloat heightForPickerView;
@property (nonatomic, readonly) CGFloat heightForToolbar;
@property (nonatomic, readonly) CGFloat heightForContentView;

@property (nonatomic, readonly) CGFloat widthForWindow;
@property (nonatomic, readonly) CGFloat heightForWindow;

@end
