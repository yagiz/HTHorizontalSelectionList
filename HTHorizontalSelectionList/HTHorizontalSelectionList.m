//
//  HTHorizontalSelectionList.m
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import "HTHorizontalSelectionList.h"
#import "HTHorizontalSelectionListLabelCell.h"

@interface HTHorizontalSelectionList () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *selectionIndicatorBar;

@property (nonatomic, strong) NSLayoutConstraint *leftSelectionIndicatorConstraint, *rightSelectionIndicatorConstraint;

@property (nonatomic, strong) UIView *bottomTrim;

@property (nonatomic, strong) NSMutableDictionary *buttonColorsByState;

@end

#define kHTHorizontalSelectionListHorizontalMargin 10
#define kHTHorizontalSelectionListInternalPadding 15

#define kHTHorizontalSelectionListSelectionIndicatorHeight 3

#define kHTHorizontalSelectionListTrimHeight 0.5

static NSString *LabelCellIdentifier = @"LabelCell";
static NSString *ViewCellIdentifier = @"ViewCell";

@implementation HTHorizontalSelectionList

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(100, 50);

        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.canCancelContentTouches = YES;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_collectionView)]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_collectionView)]];

        [_collectionView registerClass:[HTHorizontalSelectionListLabelCell class] forCellWithReuseIdentifier:LabelCellIdentifier];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ViewCellIdentifier];

        _bottomTrim = [[UIView alloc] init];
        _bottomTrim.backgroundColor = [UIColor blackColor];
        _bottomTrim.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_bottomTrim];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTrim]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_bottomTrim)]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomTrim(height)]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:@{@"height" : @(kHTHorizontalSelectionListTrimHeight)}
                                                                       views:NSDictionaryOfVariableBindings(_bottomTrim)]];

        self.buttonInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleBottomBar;

        _buttons = [NSMutableArray array];

        _selectionIndicatorBar = [[UIView alloc] init];
        _selectionIndicatorBar.translatesAutoresizingMaskIntoConstraints = NO;
        _selectionIndicatorBar.backgroundColor = [UIColor blackColor];

        _buttonColorsByState = [NSMutableDictionary dictionary];
        _buttonColorsByState[@(UIControlStateNormal)] = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    if (!self.buttons.count) {
        [self reloadData];
    }

    [super layoutSubviews];
}

#pragma mark - Custom Getters and Setters

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex {
    [self setSelectedButtonIndex:selectedButtonIndex animated:NO];
}

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    self.selectionIndicatorBar.backgroundColor = selectionIndicatorColor;

    if (!self.buttonColorsByState[@(UIControlStateSelected)]) {
        self.buttonColorsByState[@(UIControlStateSelected)] = selectionIndicatorColor;
    }
}

- (UIColor *)selectionIndicatorColor {
    return self.selectionIndicatorBar.backgroundColor;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)setBottomTrimHidden:(BOOL)bottomTrimHidden {
    self.bottomTrim.hidden = bottomTrimHidden;
}

- (BOOL)bottomTrimHidden {
    return self.bottomTrim.hidden;
}

#pragma mark - Public Methods

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.buttonColorsByState[@(state)] = color;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated {

    NSInteger buttonCount = [self.dataSource numberOfItemsInSelectionList:self];

    NSInteger oldSelectedIndex = _selectedButtonIndex;
    UIButton *oldSelectedButton;
    if (oldSelectedIndex < buttonCount && oldSelectedIndex >= 0) {
        if (oldSelectedIndex < self.buttons.count) {
            oldSelectedButton = self.buttons[oldSelectedIndex];
            oldSelectedButton.selected = NO;
        }
    }

    if (selectedButtonIndex < buttonCount && selectedButtonIndex >= 0) {
        _selectedButtonIndex = selectedButtonIndex;
    } else {
        _selectedButtonIndex = -1;
    }

    UIButton *selectedButton;

    if (_selectedButtonIndex != -1) {
        if (_selectedButtonIndex < self.buttons.count) {
            selectedButton = self.buttons[_selectedButtonIndex];
            selectedButton.selected = YES;
        }
    }

    [self layoutIfNeeded];
    [UIView animateWithDuration:animated ? 0.4 : 0.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setupSelectedButton:selectedButton oldSelectedButton:oldSelectedButton];
                     }
                     completion:nil];

    [self.collectionView scrollRectToVisible:CGRectInset(selectedButton.frame, -kHTHorizontalSelectionListHorizontalMargin, 0)
                                    animated:animated];
}

#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSelectionList:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;

    if ([self.dataSource respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ViewCellIdentifier
                                                         forIndexPath:indexPath];

        [cell.contentView addSubview:[self.dataSource selectionList:self viewForItemWithIndex:indexPath.row]];

    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:LabelCellIdentifier
                                                         forIndexPath:indexPath];

        ((HTHorizontalSelectionListLabelCell *)cell).title = [self.dataSource selectionList:self titleForItemWithIndex:indexPath.row];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.dataSource respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
        UIView *view = [self.dataSource selectionList:self viewForItemWithIndex:indexPath.row];
        return view.frame.size;
    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        // TODO return correct size for text
//        NSString *title = [self.dataSource selectionList:self viewForItemWithIndex:indexPath.row];

        return CGSizeMake(100, 30);
    }

    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return self.buttonInsets;
}

#pragma mark - Private Methods

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = self.buttonInsets;
    [button setTitle:buttonTitle forState:UIControlStateNormal];

    for (NSNumber *controlState in [self.buttonColorsByState allKeys]) {
        [button setTitleColor:self.buttonColorsByState[controlState] forState:controlState.integerValue];
    }

    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button sizeToFit];

    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (UIButton *)selectionListButtonWithView:(UIView *)buttonView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addSubview:buttonView];

    buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    buttonView.userInteractionEnabled = NO;

    CGFloat aspectRatio = buttonView.frame.size.height/buttonView.frame.size.width;

    [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:buttonView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:aspectRatio
                                                            constant:0.0]];

    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonView]|"
                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(buttonView)]];

    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[buttonView]|"
                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(buttonView)]];

    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (void)setupSelectedButton:(UIButton *)selectedButton oldSelectedButton:(UIButton *)oldSelectedButton {
    switch (self.selectionIndicatorStyle) {
        case HTHorizontalSelectionIndicatorStyleBottomBar: {
//            [self.contentView removeConstraint:self.leftSelectionIndicatorConstraint];
//            [self.contentView removeConstraint:self.rightSelectionIndicatorConstraint];

            [self alignSelectionIndicatorWithButton:selectedButton];
            [self layoutIfNeeded];
            break;
        }

        case HTHorizontalSelectionIndicatorStyleButtonBorder: {
            selectedButton.layer.borderColor = self.selectionIndicatorColor.CGColor;
            oldSelectedButton.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        }

        case HTHorizontalSelectionIndicatorStyleNone: {
            selectedButton.layer.borderColor = [UIColor clearColor].CGColor;
            oldSelectedButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)alignSelectionIndicatorWithButton:(UIButton *)button {
//    self.leftSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
//                                                                         attribute:NSLayoutAttributeLeft
//                                                                         relatedBy:NSLayoutRelationEqual
//                                                                            toItem:button
//                                                                         attribute:NSLayoutAttributeLeft
//                                                                        multiplier:1.0
//                                                                          constant:0.0];
//    [self.contentView addConstraint:self.leftSelectionIndicatorConstraint];
//
//    self.rightSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
//                                                                          attribute:NSLayoutAttributeRight
//                                                                          relatedBy:NSLayoutRelationEqual
//                                                                             toItem:button
//                                                                          attribute:NSLayoutAttributeRight
//                                                                         multiplier:1.0
//                                                                           constant:0.0];
//    [self.contentView addConstraint:self.rightSelectionIndicatorConstraint];
}

#pragma mark - Action Handlers

- (void)buttonWasTapped:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if (index != NSNotFound) {
        if (index == self.selectedButtonIndex) {
            if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleNone) {
                if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
                    [self.delegate selectionList:self didSelectButtonWithIndex:index];
                }
            }

            return;
        }

        [self setSelectedButtonIndex:index animated:YES];

        if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
            [self.delegate selectionList:self didSelectButtonWithIndex:index];
        }
    }
}

@end
