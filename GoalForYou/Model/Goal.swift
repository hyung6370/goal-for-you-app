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
    let journeys: [Journey] = []
}
