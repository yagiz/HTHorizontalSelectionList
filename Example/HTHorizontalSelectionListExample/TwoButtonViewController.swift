//
//  TwoButtonViewController.swift
//  HTHorizontalSelectionListExample
//
//  Created by Erik Ackermann on 4/8/16.
//  Copyright © 2016 Hightower. All rights reserved.
//

import UIKit

@objc class TwoButtonViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource {

    var selectionList : HTHorizontalSelectionList!
    let titles : [String] = ["Button 1", "Button 2"]
    var selectedTitleLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None

        self.selectionList = HTHorizontalSelectionList(frame: CGRectMake(0, 0, self.view.frame.size.width, 80))
        self.selectionList.delegate = self
        self.selectionList.dataSource = self

        self.selectionList.selectionIndicatorStyle = .ButtonBorder
        self.selectionList.selectionIndicatorColor = UIColor.blueColor()
        self.selectionList.bottomTrimHidden = true

        self.selectionList.centerButtons = true
        self.selectionList.evenlySpaceButtons = false

        self.selectionList.buttonInsets = UIEdgeInsetsMake(3, 10, 3, 10);

        self.view.addSubview(self.selectionList)

        self.selectedTitleLabel = UILabel()
        self.selectedTitleLabel.text = self.titles[self.selectionList.selectedButtonIndex]
        self.selectedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.selectedTitleLabel)

        self.view.addConstraint(NSLayoutConstraint(item: self.selectedTitleLabel,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0))

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[selectionList]-margin-[selectedFlowerView]",
            options: .DirectionLeadingToTrailing,
            metrics: ["margin" : 50],
            views: ["selectionList" : self.selectionList, "selectedFlowerView" : self.selectedTitleLabel]))
    }

    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods

    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return titles.count
    }

    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return titles[index]
    }

    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods

    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        // update the view for the corresponding index
        self.selectedTitleLabel.text = self.titles[index]
    }

}
