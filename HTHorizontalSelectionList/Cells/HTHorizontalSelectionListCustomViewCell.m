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

- (void)setCustomView:(UIView *)customView {
    customView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:customView];

    CGFloat aspectRatio = customView.frame.size.height/customView.frame.size.width;

    [customView addConstraint:[NSLayoutConstraint constraintWithItem:customView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:customView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:aspectRatio
                                                            constant:0.0]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(customView)]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(customView)]];
}

@end
