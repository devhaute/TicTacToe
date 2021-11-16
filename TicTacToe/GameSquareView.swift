import SwiftUI

struct GameSquareView: View {
    let proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .frame(width: proxy.size.width / 3 - 20, height: proxy.size.width / 3 - 20)
    }
}
