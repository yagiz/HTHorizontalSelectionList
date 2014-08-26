//
//  HTHorizontalSelectionList.m
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import "HTHorizontalSelectionList.h"

@interface HTHorizontalSelectionList ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *selectionIndicator;

@property (nonatomic, strong) UIView *bottomTrim;

@property (nonatomic, strong) NSMutableDictionary *buttonColorsByState;

@end

#define kHTHorizontalSelectionListHorizontalMargin 10
#define kHTHorizontalSelectionListInternalPadding 15

#define kHTHorizontalSelectionListSelectionIndicatorHeight 3

@implementation HTHorizontalSelectionList

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];

        _bottomTrim = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        _bottomTrim.backgroundColor = [UIColor blackColor];
        [self addSubview:_bottomTrim];

        _buttons = [NSMutableArray array];

        _selectionIndicator = [[UIView alloc] init];
        _selectionIndicator.backgroundColor = [UIColor blackColor];

        _buttonColorsByState = [NSMutableDictionary dictionary];
        _buttonColorsByState[@(UIControlStateNormal)] = [UIColor blackColor];
    }
    return self;
}

#pragma mark - Custom Getters and Setters

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    self.selectionIndicator.backgroundColor = selectionIndicatorColor;
}

- (UIColor *)selectionIndicatorColor {
    return self.selectionIndicator.backgroundColor;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.buttonColorsByState[@(state)] = color;
}

#pragma mark - Private Methods

- (void)layoutSubviews {
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }

    [self.selectionIndicator removeFromSuperview];
    [self.buttons removeAllObjects];

    CGFloat currentX = kHTHorizontalSelectionListHorizontalMargin;

    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];

    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = [self.dataSource selectionList:self titleForItemWithIndex:index];

        if (self.buttons.count) {
            currentX += kHTHorizontalSelectionListInternalPadding;
        }

        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        button.frame = CGRectMake(currentX,
                                  kHTHorizontalSelectionListSelectionIndicatorHeight/2,
                                  button.frame.size.width,
                                  self.scrollView.frame.size.height - kHTHorizontalSelectionListSelectionIndicatorHeight);
        currentX += button.frame.size.width;

        [self.scrollView addSubview:button];

        [self.buttons addObject:button];
    }

    self.scrollView.contentSize = CGSizeMake(currentX + kHTHorizontalSelectionListHorizontalMargin, self.scrollView.frame.size.height);

    self.selectedButtonIndex = 0;
    UIButton *firstButton = self.buttons[self.selectedButtonIndex];
    firstButton.selected = YES;

    self.selectionIndicator.frame = CGRectMake(firstButton.frame.origin.x,
                                               self.frame.size.height - kHTHorizontalSelectionListSelectionIndicatorHeight,
                                               firstButton.frame.size.width,
                                               kHTHorizontalSelectionListSelectionIndicatorHeight);

    [self.scrollView addSubview:self.selectionIndicator];
}

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button setTitle:buttonTitle.uppercaseString forState:UIControlStateNormal];

    for (NSNumber *controlState in [self.buttonColorsByState allKeys]) {
        [button setTitleColor:self.buttonColorsByState[controlState] forState:controlState.integerValue];
    }

    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button sizeToFit];

    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark - Action Handlers

- (void)buttonWasTapped:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if (index != NSNotFound) {
        if (index == self.selectedButtonIndex) {
            return;
        }

        UIButton *oldSelectedButton = self.buttons[self.selectedButtonIndex];
        oldSelectedButton.selected = NO;
        self.selectedButtonIndex = index;

        UIButton *tappedButton = (UIButton *)sender;
        tappedButton.selected = YES;

        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.selectionIndicator.frame = CGRectMake(tappedButton.frame.origin.x,
                                                                        self.frame.size.height - kHTHorizontalSelectionListSelectionIndicatorHeight,
                                                                        tappedButton.frame.size.width,
                                                                        kHTHorizontalSelectionListSelectionIndicatorHeight);
                         }
                         completion:nil];

        [self.scrollView scrollRectToVisible:CGRectInset(tappedButton.frame, -kHTHorizontalSelectionListHorizontalMargin, 0) animated:YES];

        if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
            [self.delegate selectionList:self didSelectButtonWithIndex:index];
        }
    }
}

@end
