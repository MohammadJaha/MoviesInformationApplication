# iOS Textfield Autocomplete
This is a iOS auto complete for iOS UITextField written all in Swift.

![Autocomplete Demo](http://i.imgur.com/y8TfMEs.gif)

## Installation
You can install it using CocoaPods

`pod 'CCAutocomplete'`


## Usage

### AutocompleteDelegate
The ViewController containing the UITextField should conform to `AutocompleteDelegate` protocol.
The protocol contains following methods:

#### Required methods
1. `func autoCompleteTextField() -> UITextField`: Returns UITextField we want to apply autocomplete for
2. `func autoCompleteThreshold(textField: UITextField) -> Int`: Returns minimum number of characters to start showing autocomplete
3. `func autoCompleteItemsForSearchTerm(term: String) -> [AutocompletableOption]`: Returns array of objects that conform to `AutocompletableOption` to be shown in the list of autocomplete
4. `func autoCompleteHeight() -> CGFloat`: Maximum height which shows autocomplete items
5. `func didSelectItem(item: AutocompletableOption) -> Void`: Is getting called when we tapped on the autocomplete item


#### Optional methods:

1. `func nibForAutoCompleteCell() -> UINib`: Create a nib file containing custom UITableViewCell and return it from this method to customize autocomplete cell
2. `func heightForCells() -> CGFloat`: height of custom autocomplete cells
3. `func getCellDataAssigner() -> ((UITableViewCell, AutocompletableOption) -> Void)`: returns a method that instruct Autocomplete how to assign an object that conforms to `AutocompletableOption` to a subclass of a `UITableViewCell`
4. `func animationForInsertion() -> UITableView.RowAnimation`: returns animation that is used when inserting new items into Autocomplete
5. `func animationForDeletion() -> UITableView.RowAnimation`: returns animation that is used when removing existing items from Autocomplete


### AutocompletableOption
A protocol that uses for datasource of Autocomplete UITableViewCells.
If you want to customize autocomplete cell to have more data items, you need to create an object that conforms to this.

### TODOs
There is a plan to add support multiple sections for Autocomplete. 
