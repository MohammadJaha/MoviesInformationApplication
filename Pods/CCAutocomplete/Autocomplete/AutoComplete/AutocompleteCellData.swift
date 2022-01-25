//
//  AutocompleteCellData.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/12/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

public protocol AutocompletableOption {
    var id: UUID { get }
    var text: String { get }
}

open class AutocompleteCellData: AutocompletableOption {
    fileprivate let _text: String
    fileprivate let _uuid: UUID
    
    open var text: String { get { return _text } }
    open var id: UUID { return _uuid }
    public let image: UIImage?

    public init(uuid: UUID, text: String, image: UIImage?) {
        self._text = text
        self._uuid = uuid
        self.image = image
    }
}
