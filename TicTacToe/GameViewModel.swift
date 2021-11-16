import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisable = false
    @Published var alertItem: AlertItems?
    
    func processPlayerMove(for position: Int) {
        
        //human move processing
        if isSquareOccupied(moves[position]) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkDrawCondition() {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoardDisable = true
        
        //computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerMovePosition = determineComputerMovePosition()
            moves[computerMovePosition] = Move(player: .computer, boardIndex: computerMovePosition)
            isGameBoardDisable = false
            
            if checkWinCondition(for: .computer) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkDrawCondition() {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
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
    
    func checkDrawCondition() -> Bool {
        return moves.compactMap({ $0 }).count == moves.count
    }
    
    func checkWinCondition(for player: Player) -> Bool {
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
        moves = Array(repeating: nil, count: 9)
    }
}
