//
//  TwoButtonViewController.swift
//  HTHorizontalSelectionListExample
//
//  Created by Erik Ackermann on 4/8/16.
//  Copyright © 2016 Hightower. All rights reserved.
//

import UIKit

@objc class TwoButtonViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource {

    var selectionList : HTHorizontalSelectionList?
    let titles : [String] = ["Button 1", "Button 2"]
    var selectedTitleLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None

        let selectionList = HTHorizontalSelectionList(frame: CGRectMake(0, 0, view.frame.size.width, 80))
        selectionList.delegate = self
        selectionList.dataSource = self

        selectionList.selectionIndicatorStyle = .ButtonBorder
        selectionList.selectionIndicatorColor = UIColor.blueColor()
        selectionList.bottomTrimHidden = true

        selectionList.centerButtons = true
        selectionList.evenlySpaceButtons = false

        selectionList.buttonInsets = UIEdgeInsetsMake(3, 10, 3, 10);

        view.addSubview(selectionList)

        let selectedTitleLabel = UILabel()
        selectedTitleLabel.text = titles[selectionList.selectedButtonIndex]
        selectedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedTitleLabel)

        view.addConstraint(NSLayoutConstraint(item: selectedTitleLabel,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[selectionList]-margin-[selectedFlowerView]",
            options: .DirectionLeadingToTrailing,
            metrics: ["margin" : 50],
            views: ["selectionList" : selectionList, "selectedFlowerView" : selectedTitleLabel]))

        self.selectionList = selectionList
        self.selectedTitleLabel = selectedTitleLabel
    }

    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods

    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList) -> Int {
        return titles.count
    }

    func selectionList(selectionList: HTHorizontalSelectionList, titleForItemWithIndex index: Int) -> String? {
        return titles[index]
    }

    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods

    func selectionList(selectionList: HTHorizontalSelectionList, didSelectButtonWithIndex index: Int) {
        // update the view for the corresponding index
        selectedTitleLabel?.text = titles[index]
    }

}
