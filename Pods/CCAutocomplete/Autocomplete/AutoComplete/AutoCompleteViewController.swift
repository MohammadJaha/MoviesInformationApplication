//
//  AutoCompleteViewController.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

let AutocompleteCellReuseIdentifier = "autocompleteCell"

open class AutoCompleteViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet fileprivate weak var tableView: UITableView!

    //MARK: - internal items
    internal var autocompleteItems: [AutocompletableOption]?
    internal var cellHeight: CGFloat?
    internal var cellDataAssigner: ((_ cell: UITableViewCell, _ data: AutocompletableOption) -> Void)?
    internal var textField: UITextField?
    internal let animationDuration: TimeInterval = 0.2
    internal var currentSet = Set<String>()

    //MARK: - private properties
    fileprivate var autocompleteThreshold: Int?
    fileprivate var maxHeight: CGFloat = 0
    fileprivate var height: CGFloat = 0

    //MARK: - public properties
    open weak var delegate: AutocompleteDelegate?

    //MARK: - view life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.isHidden = true
        self.textField = self.delegate!.autoCompleteTextField()

        self.height = self.delegate!.autoCompleteHeight()
        self.view.frame = CGRect(x: self.textField!.frame.minX,
            y: self.textField!.frame.maxY,
            width: self.textField!.frame.width,
            height: self.height)

        self.tableView.register(self.delegate!.nibForAutoCompleteCell(), forCellReuseIdentifier: AutocompleteCellReuseIdentifier)

        self.textField?.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: UIControl.Event.editingChanged)
        self.autocompleteThreshold = self.delegate!.autoCompleteThreshold(self.textField!)
        self.cellDataAssigner = self.delegate!.getCellDataAssigner()

        self.cellHeight = self.delegate!.heightForCells()
        // not to go beyond bound height if list of items is too big
        self.maxHeight = UIScreen.main.bounds.height - self.view.frame.minY
    }

    //MARK: - private methods
    @objc func textDidChange(_ textField: UITextField) {
        let numberOfCharacters = textField.text?.count
        if let numberOfCharacters = numberOfCharacters {
            if numberOfCharacters > self.autocompleteThreshold! {
                self.view.isHidden = false
                guard let searchTerm = textField.text else { return }
                let newItems = self.delegate!.autoCompleteItemsForSearchTerm(searchTerm)
                let oldItems = self.autocompleteItems
                self.autocompleteItems = newItems
                UIView.animate(withDuration: self.animationDuration,
                    delay: 0.0,
                    options: UIView.AnimationOptions(),
                    animations: { () -> Void in
                        self.view.frame.size.height = min(
                            CGFloat(self.autocompleteItems!.count) * CGFloat(self.cellHeight!),
                            self.maxHeight,
                            self.height
                        )
                    },
                    completion: nil)
                
                var removedIndexPaths = [IndexPath]()
                let newSet = Set(newItems.map{ $0.text })
                
                if let autocompleteItems = oldItems {
                    for i in stride(from: 0, to: autocompleteItems.count, by: 1) {
                        if !newSet.contains(autocompleteItems[i].text) {
                            removedIndexPaths.append(IndexPath(row: i, section: 0))
                        }
                    }
                }
                
                
                var insertedIndexPaths = [IndexPath]()
                for i in stride(from: 0, to: newItems.count, by: 1) {
                    if !currentSet.contains(newItems[i].text) {
                        insertedIndexPaths.append(IndexPath(row: i, section: 0))
                    }
                }
                
                
                currentSet = newSet
                
                self.tableView.beginUpdates()
                if newSet.count != 0 && self.tableView.numberOfSections == 0 {
                    self.tableView.insertSections(IndexSet(integer: 0), with: self.delegate?.animationForInsertion() ?? .fade)
                }
                
                if newSet.count == 0 && self.tableView.numberOfSections > 0 {
                    self.tableView.deleteSections(IndexSet(integer: 0), with: self.delegate?.animationForInsertion() ?? .fade)
                }
                
                self.tableView.insertRows(at: insertedIndexPaths, with: self.delegate?.animationForInsertion() ?? .fade)
                self.tableView.deleteRows(at: removedIndexPaths, with: self.delegate?.animationForInsertion() ?? .fade)
                self.tableView.endUpdates()
                
            } else {
                self.view.isHidden = true
            }
        }
    }

}
