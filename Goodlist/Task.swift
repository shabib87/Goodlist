//
//  Task.swift
//  Goodlist
//
//  Created by Shabib Hossain on 2019-10-20.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high, medium, low
}
struct Task {
    let title: String
    let priority: Priority
}
