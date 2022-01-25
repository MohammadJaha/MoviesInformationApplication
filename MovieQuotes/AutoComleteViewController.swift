//
//  AutoComleteViewController.swift
//  MovieQuotes
//
//  Created by admin on 21/12/2021.
//

import UIKit
import CCAutocomplete

class AutoComleteViewController: UIViewController {

    weak var autoComleteDelegate: AutoCompleteDelegate?
    let autoCompleteList = MoviesNames().moviesNameList
    
    var autocompleteTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Search Movie Name"
        textField.font = .systemFont(ofSize: 17, weight: .bold)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .lightGray
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    var backgroundImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "defaultImage")
        image.contentMode = .scaleToFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(autocompleteTextfield)
        autocompleteTextfield.frame = CGRect(x: 10, y: 5, width: view.bounds.width - 20, height: 50)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        Autocomplete.setupAutocompleteForViewcontroller(self)
    }

}

extension AutoComleteViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return autocompleteTextfield
    }
    
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 0
    }
    
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredNames = self.autoCompleteList.filter { (movieName) -> Bool in
            return movieName.lowercased().contains(term.lowercased())
        }
        
        let moviesNames: [AutocompletableOption] = filteredNames.map { ( movieName) -> AutocompleteCellData in
            var name = movieName
            name.replaceSubrange(name.startIndex...name.startIndex, with: String(name[name.startIndex]).capitalized)
            return AutocompleteCellData(uuid: UUID(),
                                        text: name,
                                        image: UIImage())
        }.map( { $0 as AutocompletableOption })
        
        return moviesNames
    }
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height - 150
    }
    
    func didSelectItem(_ item: AutocompletableOption) {
        autoComleteDelegate?.autoCompleteSelected(selectedName: item.text)
        dismiss(animated: true, completion: nil)
    }
    
    
}
