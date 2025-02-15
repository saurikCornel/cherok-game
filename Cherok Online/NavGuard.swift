import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case SETTINGS
    case RULES
    case SHOP
    case MAINGAME
    case AIGAME
    case HOWTOMAIN
    case HOWTOAI
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: NavGuard = .init()
}
