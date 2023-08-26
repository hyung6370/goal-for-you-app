//
//  Goal.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/23.
//

import UIKit

struct Goal {
    var title: String?
    var description: String?
    var reminderDate: String?
    var uniqueId: String?
    var done: Bool = false
    let journeys: [Journey] = []
    
    init(title: String? = nil, description: String? = nil, reminderDate: String? = nil, uniqueId: String? = nil, done: Bool) {
        self.title = title
        self.description = description
        self.reminderDate = reminderDate
        self.uniqueId = uniqueId
        self.done = done
    }
}
