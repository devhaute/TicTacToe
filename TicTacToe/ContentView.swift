import SwiftUI

struct ContentView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisable = false
    @State private var alertItem: AlertItems?
    
    func isSquareOccupied(_ move: Move?) -> Bool {
        move == nil ? false : true
    }
    
    func determineComputerMovePosition() -> Int {
        var movePosition = Int.random(in: 0...8)
        
        while isSquareOccupied(moves[movePosition]) {
            movePosition = Int.random(in: 0...8)
        }
        
        return movePosition
    }
    
    func checkDrawCondition(_ moves: [Move?]) -> Bool {
        return moves.compactMap({ $0 }).count == moves.count
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
        ]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map({ move in move.boardIndex }))
        
        for pattern in winPattern where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func resetGame() {
        self.moves = Array(repeating: nil, count: 9)
    }
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<9) { index in
                    ZStack {
                        Circle()
                            .frame(width: proxy.size.width / 3 - 20, height: proxy.size.width / 3 - 20)
                        
                        Image(systemName: moves[index]?.indicator ?? "")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        if isSquareOccupied(moves[index]) { return }
                        self.moves[index] = Move(player: .human, boardIndex: index)
                        
                        if checkDrawCondition(moves) {
                            alertItem = AlertContext.draw
                            return
                        }
                        if checkWinCondition(for: .human, in: moves) {
                            alertItem = AlertContext.humanWin
                            return
                        }
                        
                        self.isGameBoardDisable = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let computerMovePosition = determineComputerMovePosition()
                            self.moves[computerMovePosition] = Move(player: .computer, boardIndex: computerMovePosition)
                            self.isGameBoardDisable = false
                            
                            if checkDrawCondition(moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            if checkWinCondition(for: .computer, in: moves) {
                                alertItem = AlertContext.computerWin
                                return
                                
                            }
                        }
                    }
                    .alert(item: $alertItem) { alertItem in
                        Alert(
                            title: alertItem.title,
                            message: alertItem.message,
                            dismissButton: .default(alertItem.buttonTitle, action: {
                                resetGame()
                            }                   )
                        )
                    }
                }
            }
            .disabled(isGameBoardDisable)
            .padding(5)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "circle" : "xmark"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
