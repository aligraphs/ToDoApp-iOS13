//
//  Category.swift
//  ToDoApp-iOS13
//
//  Created by Ali Ünal on 14/12/2020.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
