//
//  AutoCompleteDelegate.swift
//  MovieQuotes
//
//  Created by admin on 21/12/2021.
//

import Foundation

protocol AutoCompleteDelegate: AnyObject {
    func autoCompleteSelected(selectedName name: String)
}
