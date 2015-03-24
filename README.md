HTHorizontalSelectionList
=========================

A simple, horizontally-scrolling list of items that can be used as a more flexible replacement for UISegmentedControl

##Example

A simple side-scrolling list of items (perhaps filters for a UITableView below).
![alt tag](docs/car_list.gif)

##Setup via CocoaPods

Add HTHorizontalSelectionList pod into your Podfile
```
pod 'HTHorizontalSelectionList', '~> 0.4.7'
```

##Usage
###Setup and Initialization

To begin using HTHorizontalSelectionList, import the main header:
```objc
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
```

The horizontal selection list uses a data-source/delegate model (similar to UITableView or UIPickerView).  To setup a simple horizontal selection list, init the view and set it's delegate and data source:
```objc
@interface CarListViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSArray *carMakes;

@end

@implementation CarListViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
	selectionList.delegate = self;
	selectionList.dataSource = self;

	self.carMakes = @[@"ALL CARS",
                      @"AUDI",
                      @"BITTER",
                      @"BMW",
                      @"BÜSSING",
                      @"GUMPERT",
                      @"MAN"];
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

```

###Customizing the appearance

The HTHorizontalSelectionList has a number of configurable properties.

To adjust the selected color of the buttons use the following method:
```objc
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
```

Additionally, you can set the selection indicator color with these proprties:
```objc
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

@property (nonatomic) HTHorizontalSelectionIndicatorStyle selectionIndicatorStyle;
```

There are three selection styles:
```objc
typedef NS_ENUM(NSInteger, HTHorizontalSelectionIndicatorStyle) {
    HTHorizontalSelectionIndicatorStyleBottomBar,           // Default
    HTHorizontalSelectionIndicatorStyleButtonBorder,
    HTHorizontalSelectionIndicatorStyleNone
};
```

You can adjust the content insets of each button with:
```objc
@property (nonatomic) UIEdgeInsets buttonInsets;
```

Setting `bottomTrimColor` changes the appearance of the thin line below the entire view:
```objc
@property (nonatomic, strong) UIColor *bottomTrimColor;
@property (nonatomic) BOOL bottomTrimHidden;
```
