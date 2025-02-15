import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: NavGuard = NavGuard.shared
    var body: some View {
        switch nav.currentScreen {
                                        
        case .MENU:
            MenuView()
        case .LOADING:
            LoadingScreen()
        case .SETTINGS:
            SettingsView()
        case .RULES:
            RulesView()
        case .SHOP:
            ShopView()
        case .MAINGAME:
            GameView()
        case .AIGAME:
            GameAi()
        case .HOWTOMAIN:
            HowToPlayMain()
        case .HOWTOAI:
            HowToPlayAi()
        }

    }
}
