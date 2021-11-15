import SwiftUI

struct ContentView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumansTurn = true
    
    func isSquareOccupied(_ move: Move?) -> Bool {
        move == nil ? false : true
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
                            
                        self.moves[index] = Move(player: self.isHumansTurn ? .human : .computer, boardIndex: index)
                        self.isHumansTurn.toggle()
                    }
                }
            }
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
