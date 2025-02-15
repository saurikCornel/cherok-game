import SwiftUI

struct HowToPlayMain: View {
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        Image(.rules)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MAINGAME
                            }
                    }
                    
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                            .scaleEffect(2)
                        
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundHow)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )

        }
    }
}



#Preview {
    HowToPlayMain()
}


