import SwiftUI

struct GameView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: gameViewModel.columns, spacing: 20) {
                ForEach(0..<9) { index in
                    ZStack {
                        GameSquareView(proxy: proxy)
                        PlayerIndicator(systemImageName: gameViewModel.moves[index]?.indicator ?? "")
                    }
                    .onTapGesture {
                        gameViewModel.processPlayerMove(for: index)
                    }
                    .alert(item: $gameViewModel.alertItem) { alertItem in
                        Alert(
                            title: alertItem.title,
                            message: alertItem.message,
                            dismissButton: .default(alertItem.buttonTitle, action: {
                                gameViewModel.resetGame()
                            }                   )
                        )
                    }
                }
            }
            .disabled(gameViewModel.isGameBoardDisable)
            .padding(5)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
