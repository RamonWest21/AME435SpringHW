struct MyQuestionAnswerer {
    func responseTo(question: String) -> String {
        
        let lowerQuestion = question.lowercased()
        
        if lowerQuestion == "where are the cookies?" {
            return "In the cookie jar!"
        }
        else if lowerQuestion == "what is your name?" {
            return "My name is HAL, I am an Heuristically Programmed ALgorithmic Computer."
        }
        else if lowerQuestion.hasPrefix("can you") {
            return "🙅‍♂️ I'm afraid I can't do that."
        }
        else if lowerQuestion.hasPrefix("where") {
            return "To the North!"
        }
        else if lowerQuestion.hasPrefix("what") {
            return "That!"
        }
        else if lowerQuestion.hasPrefix("hello") {
            return "Howdy!"
        }
        else {
            
            let defaultNumber = question.count % 6
            
            if defaultNumber == 0 {
                return "🤷‍♂️ That really depends."
            }
            else if defaultNumber == 1 {
                return "🧞‍♂️ Ask me again tomorrow. "
            }
            else if defaultNumber == 2 {
                return "😆 I wish I could tell you."
            }
            else if defaultNumber == 3 {
                return "💁‍♂️ I'm not sure I understand."
            }
            else if defaultNumber == 4 {
                return "Are you sure you are spelling that correctly?"
            }
            else {
                return "Go bother Alexa with that."
            }
            
        }
    }
}
