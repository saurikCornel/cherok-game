import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    
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
                        
                        Image(.settingsPlate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 300)
                            .padding(.top, 50)
                        
                        VStack(spacing: 10) {
                            HStack(spacing: 20) {
                                Image(.musicIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 80)
                                
                                if settings.musicEnabled {
                                    Image(.soundOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                } else {
                                    Image(.soundOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                }
                            }
                            
                            HStack(spacing: 20) {
                                Image(.vibroIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 80)
                                
                                if settings.vibroEnabled {
                                    Image(.soundOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                } else {
                                    Image(.soundOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                }
                            }
                            
                            
                            HStack(spacing: 50) {
                                Image(.contactUsBtn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        openURLInSafari(urlString: openAppURL)
                                    }
                                
                                Image(.rateUsBtn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        openURLInSafari(urlString: openAppURL)
                                    }
                                
                            }
                            
                        }
                        .padding(.top, 40)
                        
                        
                        
                    }
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

extension SettingsView {
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Не удалось открыть URL: \(urlString)")
            }
        } else {
            print("Неверный формат URL: \(urlString)")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}


