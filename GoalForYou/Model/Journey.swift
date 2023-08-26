//
//  Journey.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/25.
//

import Foundation

struct Journey {
    var journeyId: String?
    var journeyTitle: String?
    var journeyDescription: String?
    var done: Bool = false
    var journeyReminderDate: String?
    
    init(journeyId: String? = nil, journeyTitle: String? = nil, journeyDescription: String? = nil, done: Bool, journeyReminderDate: String? = nil) {
        self.journeyId = journeyId
        self.journeyTitle = journeyTitle
        self.journeyDescription = journeyDescription
        self.done = done
        self.journeyReminderDate = journeyReminderDate
    }
}
