import Foundation
class ConversationDataSource {
    
    /// The number of Messages in the conversation
    var messageCount: Int {
        return messages.count
    }
    var messages = [openingLine]
    
    
    /// Add a new question to the conversation
    func add(question: String) {
        let message = Message(date: Date(), text: question, type: .question)
        messages.append(message)
        print("Asked to add question: \(question)")
            }
    
    /// Add a new answer to the conversation
    func add(answer: String) {
        let message = Message(date: Date(), text: answer, type: .answer)
        messages.append(message)
        print("Asked to add answer: \(answer)")
        }
    
    /// The Message at a specific point in the conversation
    func messageAt(index: Int) -> Message {
        print("Asking for message at index \(index)")
       
//        if index % 2 == 0
//        {
//            return Message(date: Date(), text: "Question \(index / 2)", type: .question)
//        }
//        else
//        {
//            return Message(date: Date(), text: "Answer \(index / 2)", type: .answer)
//        }
        return messages[index]
        
    }
}
