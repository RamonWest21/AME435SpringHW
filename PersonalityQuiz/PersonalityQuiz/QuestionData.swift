//
//  QuestionData.swift
//  PersonalityQuiz
//
//  Created by student on 2/24/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import Foundation

struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType{
    case single, multiple, ranged
}

struct Answer {
    var text: String
    var type: AnimalType
}

enum AnimalType: Character {
    case dog = "🐶", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    
    var definition: String {
        switch self {
        case .dog:
            return "You are incredibly outgoing. You surround yourself with the peiple you love and enjoy activities with your friends."
        case .cat:
            return "You are the worst."
        case .rabbit:
            return "You are smelly, but cute and full of energy."
        case .turtle:
            return "You are wise and focused, like the great Jedi of the old Republic. Not as cute or as fast as rabbit, but you just might win the race."
        }
    }
}
