import SwiftUI

struct PlayerIndicator: View {
    let systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
    }
}
