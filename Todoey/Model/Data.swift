//
//  Data.swift
//  Todoey
//
//  Created by Sebastian Paulus on 17/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
   @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
