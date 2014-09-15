//
//  ViewController.m
//  HTHorizontalSelectionList Example
//
//  Created by Erik Ackermann on 9/14/14.
//  Copyright (c) 2014 Hightower. All rights reserved.
//

#import "ViewController.h"
#import "HTHorizontalSelectionList.h"

@interface ViewController () <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSArray *carMakes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example App";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    
    self.carMakes = @[@"All cars",
                      @"Audi",
                      @"Bitter",
                      @"BMW",
                      @"Büssing",
                      @"Gumpert",
                      @"MAN"];
    
    [self.view addSubview:self.selectionList];
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.carMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.carMakes[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
}

@end
