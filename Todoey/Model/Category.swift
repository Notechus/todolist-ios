//
//  Category.swift
//  Todoey
//
//  Created by Sebastian Paulus on 17/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<TodoItem>()
}
