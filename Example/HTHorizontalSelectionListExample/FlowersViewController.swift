//
//  FlowersViewController.swift
//  HTHorizontalSelectionListExample
//
//  Created by Erik Ackermann on 3/25/15.
//  Copyright (c) 2015 Hightower. All rights reserved.
//

import UIKit

@objc class FlowersViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource {

    var selectionList : HTHorizontalSelectionList!
    let flowers : [UIImageView] = [UIImageView(image: UIImage(named: "flower1.jpeg")),
        UIImageView(image: UIImage(named: "flower2.jpeg")),
        UIImageView(image: UIImage(named: "flower3.jpeg")),
        UIImageView(image: UIImage(named: "flower4.jpeg")),
        UIImageView(image: UIImage(named: "flower5.jpeg")),
        UIImageView(image: UIImage(named: "flower6.jpeg")),
        UIImageView(image: UIImage(named: "flower7.jpeg")),
        UIImageView(image: UIImage(named: "flower8.jpeg"))]
    var selectedFlowerView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Flowers"
        self.edgesForExtendedLayout = .None

        self.selectionList = HTHorizontalSelectionList(frame: CGRectMake(0, 0, self.view.frame.size.width, 80))
        self.selectionList.delegate = self
        self.selectionList.dataSource = self

        self.selectionList.selectionIndicatorStyle = .ButtonBorder
        self.selectionList.selectionIndicatorColor = UIColor.blueColor()
        self.selectionList.bottomTrimHidden = true
        self.selectionList.centerAlignButtons = true

        self.selectionList.buttonInsets = UIEdgeInsetsMake(3, 10, 3, 10);

        self.view.addSubview(self.selectionList)

        self.selectedFlowerView = UIImageView()
        var selectedImage = self.flowers[self.selectionList.selectedButtonIndex].image
        self.selectedFlowerView.image = selectedImage
        self.selectedFlowerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.selectedFlowerView)

        self.view.addConstraint(NSLayoutConstraint(item: self.selectedFlowerView,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0))

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[selectionList]-margin-[selectedFlowerView]",
            options: .DirectionLeadingToTrailing,
            metrics: ["margin" : 50],
            views: ["selectionList" : self.selectionList, "selectedFlowerView" : self.selectedFlowerView]))
    }

    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods

    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return flowers.count
    }

    func selectionList(selectionList: HTHorizontalSelectionList!, viewForItemWithIndex index: Int) -> UIView! {
        return flowers[index]
    }

    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods

    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        // update the view for the corresponding index
        self.selectedFlowerView.image = self.flowers[index].image
    }

}
