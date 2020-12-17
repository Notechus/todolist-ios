//
//  TodoItem.swift
//  Todoey
//
//  Created by Sebastian Paulus on 17/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
