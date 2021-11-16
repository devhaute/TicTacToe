import SwiftUI

struct AlertItems: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItems(
        title: Text("You Win!"),
        message: Text("You are so smart. You beat your own AI."),
        buttonTitle: Text("Hell yeah")
    )
    
    static let computerWin = AlertItems(
        title: Text("You Lost!"),
        message: Text("You programmed a super AI."),
        buttonTitle: Text("Rematch")
    )
    
    static let draw = AlertItems(
        title: Text("Draw"),
        message: Text("What a battle of wits we have here..."),
        buttonTitle: Text("Try Again")
    )
}
