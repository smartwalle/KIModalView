//
//  KIBasePickerView.m
//  Kitalker
//
//  Created by Kitalker on 14/9/26.
//  Copyright (c) 2014年 Kitalker. All rights reserved.
//

#import "KIBasePickerView.h"

@interface KIBasePickerView () {
    UILabel         *_titleLabel;
    UIToolbar       *_toolbar;
    
    UIBarButtonItem *_cancelButtonItem;
    UIBarButtonItem *_confirmButtonItem;
    UIBarButtonItem *_flexibleSpaceButtonItem;
}

@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpaceButtonItem;

@end

@implementation KIBasePickerView

#pragma mark - Lifecycle
- (void)dealloc {
    _title = nil;
    
    _titleLabel = nil;
    _cancelButtonItem = nil;
    _confirmButtonItem = nil;
    _flexibleSpaceButtonItem = nil;
    _toolbar = nil;
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Methods
- (void)setup {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setWindowFrame:window.frame];
}

- (void)show {
    [self setTransitionIn:KIModalViewTransitionFlipFromBottom];
    [self setTransitionOut:KIModalViewTransitionFlipToBottom];
    [self setDockToSide:KIModalViewDockOnTheBottom];
    [super show];
    
    [self.titleLabel setText:self.title];
}

- (void)cancel {
}

- (void)confirm {
}

- (CGFloat)heightForPickerView {
    return ([UIScreen mainScreen].bounds.size.height <= 480 ? 162 : 216.0f);
}

- (CGFloat)heightForToolbar {
    return 44.0f;
}

- (CGFloat)heightForContentView {
    return self.heightForPickerView + self.heightForToolbar;
}

- (CGFloat)widthForWindow {
    return CGRectGetWidth(self.windowFrame);
}

- (CGFloat)heightForWindow {
    return CGRectGetHeight(self.windowFrame);
}

#pragma mark - Getters and setters
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                CGRectGetWidth(self.windowFrame),
                                                                self.heightForContentView)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView addSubview:[self pickerView]];
        [_contentView addSubview:[self toolbar]];
    }
    return _contentView;
}

- (UIView *)pickerView {
    return nil;
}

- (UIToolbar *)toolbar {
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] init];
        [_toolbar setBarStyle:UIBarStyleDefault];
        [_toolbar setFrame:CGRectMake(0, 0, CGRectGetWidth(self.windowFrame), self.heightForToolbar)];
        
        UIBarButtonItem *paddingLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
        [paddingLeft setWidth:5];
        
        UIBarButtonItem *paddingRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
        [paddingRight setWidth:5];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:paddingLeft];
        [items addObject:[self cancelButtonItem]];
        [items addObject:[self flexibleSpaceButtonItem]];
        [items addObject:[self confirmButtonItem]];
        [items addObject:paddingRight];
        [_toolbar setItems:items];
    }
    return _toolbar;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        
        CGFloat x = (CGRectGetWidth(self.windowFrame) - 160) / 2;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 160, self.heightForToolbar)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        UIColor *textColor = [UIColor whiteColor];
        if (systemVersion >= 7.0) {
            textColor = [UIColor grayColor];
        }
        [_titleLabel setTextColor:textColor];
        
        [_titleLabel setNumberOfLines:1];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    if (_titleLabel != nil) {
        [_titleLabel setText:_title];
    }
}

- (UIBarButtonItem *)flexibleSpaceButtonItem {
    if (_flexibleSpaceButtonItem == nil) {
        _flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    }
    return _flexibleSpaceButtonItem;
}

- (UIBarButtonItem *)cancelButtonItem {
    if (_cancelButtonItem == nil) {
        _cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(cancel)];
    }
    return _cancelButtonItem;
}

- (UIBarButtonItem *)confirmButtonItem {
    if (_confirmButtonItem == nil) {
        _confirmButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil)
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(confirm)];
    }
    return _confirmButtonItem;
}

@end
