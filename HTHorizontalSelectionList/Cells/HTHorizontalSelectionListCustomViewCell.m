//
//  HTHorizontalSelectionListCustomViewCell.m
//  HTHorizontalSelectionList Example
//
//  Created by Erik Ackermann on 2/27/15.
//  Copyright (c) 2015 Hightower. All rights reserved.
//

#import "HTHorizontalSelectionListCustomViewCell.h"

@implementation HTHorizontalSelectionListCustomViewCell

@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _state = UIControlStateNormal;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    for (UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }

    self.state = UIControlStateNormal;
}

#pragma mark - Custom Getters and Setters

- (void)setCustomView:(UIView *)customView {
    customView.translatesAutoresizingMaskIntoConstraints = NO;

    if (customView) {
        [self.contentView addSubview:customView];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(customView)]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(customView)]];
    }
}

@end
