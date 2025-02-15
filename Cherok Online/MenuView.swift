import SwiftUI

struct MenuView: View {
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                        ZStack {
                            
                            VStack {
                                ButtonTemplateBig(image: "withAiBtn", action: {NavGuard.shared.currentScreen = .HOWTOAI})
                                
                                ButtonTemplateBig(image: "twoPlayerBtn", action: {NavGuard.shared.currentScreen = .HOWTOMAIN})
                            }

                            VStack {
                                
                                HStack  {
                                    ButtonTemplateSmall(image: "howToPlayBtn", action: {NavGuard.shared.currentScreen = .RULES})
                                    Spacer()
                                    ButtonTemplateSmall(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                                }
                                
                                Spacer()
                                
                                HStack  {
                                    ButtonTemplateSmall(image: "shopBtn", action: {NavGuard.shared.currentScreen = .SHOP})
                                    Spacer()
                                    BalanceTemplate()
                                }
                            }
                        }
                        .padding(.top, 10)
                    
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
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
//            .overlay(
//                ZStack {
//                    if isLandscape {
//                        HStack {
//                            BalanceTemplate()
//                        }
//                        .position(x: geometry.size.width / 1.2, y: geometry.size.height / 9)
//                    } else {
//                        BalanceTemplate()
//                            .position(x: geometry.size.width / 1.3, y: geometry.size.height / 9)
//                    }
//                }
//            )

        }
    }
}




struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 50
    var body: some View {
        ZStack {
            Image(.balanceTemplate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 60, y: 35)
                        
                    }
                )
        }
    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}

