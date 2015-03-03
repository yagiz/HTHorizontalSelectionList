//
//  HTHorizontalSelectionList.m
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import "HTHorizontalSelectionList.h"
#import "HTHorizontalSelectionListLabelCell.h"
#import "HTHorizontalSelectionListCustomViewCell.h"

@interface HTHorizontalSelectionList () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *selectionIndicatorBar;
@property (nonatomic, strong) UIView *bottomTrim;

@property (nonatomic, strong) NSMutableDictionary *buttonColorsByState;

@end

#define kHTHorizontalSelectionListHorizontalMargin 10

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
        [_collectionView registerClass:[HTHorizontalSelectionListCustomViewCell class] forCellWithReuseIdentifier:ViewCellIdentifier];

        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView addSubview:_contentView];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];

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
        
        _font = [UIFont systemFontOfSize:13];

        _selectionIndicatorBar = [[UIView alloc] init];
        _selectionIndicatorBar.translatesAutoresizingMaskIntoConstraints = NO;
        _selectionIndicatorBar.backgroundColor = [UIColor blackColor];

        _buttonColorsByState = [NSMutableDictionary dictionary];
        _buttonColorsByState[@(UIControlStateNormal)] = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    [self reloadData];

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
    [self.collectionView layoutIfNeeded];

    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];

    if (totalButtons < 1) {
        return;
    }

    if (_selectedButtonIndex > totalButtons - 1) {
        _selectedButtonIndex = -1;
    }

    if (totalButtons > 0 && self.selectedButtonIndex >= 0 && self.selectedButtonIndex < totalButtons) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedButtonIndex inSection:0]];

        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateSelected;

        switch (self.selectionIndicatorStyle) {
            case HTHorizontalSelectionIndicatorStyleBottomBar: {
                [self.contentView addSubview:self.selectionIndicatorBar];

                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectionIndicatorBar(height)]|"
                                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                         metrics:@{@"height" : @(kHTHorizontalSelectionListSelectionIndicatorHeight)}
                                                                                           views:NSDictionaryOfVariableBindings(_selectionIndicatorBar)]];


                [self alignSelectionIndicatorWithCell:cell];
                break;
            }

            case HTHorizontalSelectionIndicatorStyleButtonBorder: {
                cell.layer.borderColor = self.selectionIndicatorColor.CGColor;
                break;
            }

            default:
                break;
        }
    }

    [self sendSubviewToBack:self.bottomTrim];

    [self updateConstraintsIfNeeded];
}

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated {

    NSInteger buttonCount = [self.dataSource numberOfItemsInSelectionList:self];

    NSInteger oldSelectedIndex = _selectedButtonIndex;
    if (selectedButtonIndex < buttonCount && selectedButtonIndex >= 0) {
        _selectedButtonIndex = selectedButtonIndex;
    } else {
        _selectedButtonIndex = -1;
    }

    UICollectionViewCell *oldSelectedCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:oldSelectedIndex
                                                                                                            inSection:0]];

    UICollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedButtonIndex
                                                                                                         inSection:0]];

    [self layoutIfNeeded];
    [UIView animateWithDuration:animated ? 0.4 : 0.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setupSelectedCell:selectedCell oldSelectedCell:oldSelectedCell];
                     }
                     completion:nil];

    if (selectedCell) {
        [self.collectionView scrollRectToVisible:CGRectInset(selectedCell.frame, -kHTHorizontalSelectionListHorizontalMargin, 0)
                                        animated:animated];
    }
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

        [((HTHorizontalSelectionListCustomViewCell *)cell) setCustomView:[self.dataSource selectionList:self viewForItemWithIndex:indexPath.item]];
    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:LabelCellIdentifier
                                                         forIndexPath:indexPath];

        ((HTHorizontalSelectionListLabelCell *)cell).title = [self.dataSource selectionList:self titleForItemWithIndex:indexPath.item];
        ((HTHorizontalSelectionListLabelCell *)cell).font = self.font;
        for (NSNumber *controlState in [self.buttonColorsByState allKeys]) {
            [((HTHorizontalSelectionListLabelCell *)cell) setTitleColor:self.buttonColorsByState[controlState]
                                                               forState:controlState.integerValue];
        }
    }

    if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleButtonBorder) {
        cell.layer.borderWidth = 1.0;
        cell.layer.cornerRadius = 3.0;
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.layer.masksToBounds = YES;
    }

    if (indexPath.item == self.selectedButtonIndex) {
        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateSelected;
    } else {
        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateNormal;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.dataSource respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
        UIView *view = [self.dataSource selectionList:self viewForItemWithIndex:indexPath.item];

        CGFloat maxHeight = self.frame.size.height - self.buttonInsets.top - self.buttonInsets.bottom;
        CGFloat height = MIN(maxHeight, view.frame.size.height);

        if (self.frame.size.height) {
            CGFloat scaleFactor = height / view.frame.size.height;

            CGFloat width = view.frame.size.width * scaleFactor;

            return CGSizeMake(width, height);
        } else {
            return view.frame.size;
        }

    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        NSString *title = [self.dataSource selectionList:self titleForItemWithIndex:indexPath.item];
        return [HTHorizontalSelectionListLabelCell sizeForTitle:title withFont:self.font];
    }

    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return self.buttonInsets;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedButtonIndex) {
        if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleNone) {
            if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
                [self.delegate selectionList:self didSelectButtonWithIndex:indexPath.item];
            }
        }

        return;
    }

    [self setSelectedButtonIndex:indexPath.item animated:YES];

    if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
        [self.delegate selectionList:self didSelectButtonWithIndex:indexPath.item];
    }
}

#pragma mark - Private Methods

- (void)setupSelectedCell:(UICollectionViewCell *)selectedCell oldSelectedCell:(UICollectionViewCell *)oldSelectedCell {
    ((id<HTHorizontalSelectionListCell>)selectedCell).state = UIControlStateSelected;
    ((id<HTHorizontalSelectionListCell>)oldSelectedCell).state = UIControlStateNormal;

    switch (self.selectionIndicatorStyle) {
        case HTHorizontalSelectionIndicatorStyleBottomBar: {
            [self alignSelectionIndicatorWithCell:selectedCell];
            break;
        }

        case HTHorizontalSelectionIndicatorStyleButtonBorder: {
            selectedCell.layer.borderColor = self.selectionIndicatorColor.CGColor;
            oldSelectedCell.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        }

        case HTHorizontalSelectionIndicatorStyleNone: {
            selectedCell.layer.borderColor = [UIColor clearColor].CGColor;
            oldSelectedCell.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)alignSelectionIndicatorWithCell:(UICollectionViewCell *)cell {
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:cell];

    if (selectedIndexPath) {
        [self layoutIfNeeded];

        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:selectedIndexPath];
        CGRect cellRect = attributes.frame;

        self.selectionIndicatorBar.frame = CGRectMake(cellRect.origin.x,
                                                      self.selectionIndicatorBar.frame.origin.y,
                                                      cellRect.size.width,
                                                      self.selectionIndicatorBar.frame.size.height);
    }
}

@end
