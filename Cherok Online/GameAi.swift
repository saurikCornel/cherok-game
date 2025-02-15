import SwiftUI
import SpriteKit

struct GameAi: View {
    @AppStorage("player1Score") var player1Score = 0
    @AppStorage("player2Score") var player2Score = 0
    
    @State private var showModal = false
    @State private var currentPlayer: Int = 1 // 1 - Player 1, 2 - Player 2
    @State private var gameID = UUID() // Добавляем переменную для пересоздания сцены
    

    
    
    var scene: SKScene {
        let scene = GameAiClass(currentPlayer: $currentPlayer)
        scene.size = CGSize(width: 320, height: 320)
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        Image(.plate)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 335, height: 335)

                        HStack {
                            Spacer()
                            Image(.scorePlate)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 190, height: 100)
                                .overlay(
                                    ZStack {
                                        Text("\(player1Score):\(player2Score)")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 30, weight: .bold, design: .default))
                                            .padding(.top, 25)
                                    }
                                )
                        }

                        VStack {
                            HStack {
                                Image(currentPlayer == 1 ? .player1Go : .player1Wait)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 50)
                                    .padding()
                                Spacer()
                                Image(currentPlayer == 2 ? .player2Go : .player2Wait)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 50)
                                    .padding()
                            }
                            Spacer()
                        }

                        SpriteView(scene: scene)
                            .frame(width: 320, height: 320)
                            .ignoresSafeArea()
                            .id(gameID) // Используем gameID для принудительного пересоздания
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(
                        Image(.backgroundGame)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .scaleEffect(1.1)
                    )
                    .sheet(isPresented: $showModal) {
        //                WinnerModal(player1Score: player1Score, player2Score: player2Score) {
        //                    restartGame()
        //                }
                        
                        if player1Score == 8 {
                            WinView(retryAction: restartGame)
                        } else {
                            LoseView(retryAction: restartGame)
                        }
                    }
                    .onChange(of: player1Score) { newValue in
                        guard !showModal else { return } // Предотвращаем повторное открытие
                        if newValue >= 8 {
                            showModal = true
                        }
                    }
                    .onChange(of: player2Score) { newValue in
                        guard !showModal else { return } // Предотвращаем повторное открытие
                        if newValue >= 8 {
                            showModal = true
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
        
        }
    }
    

    private func restartGame() {
        player1Score = 0
        player2Score = 0
        showModal = false
        currentPlayer = 1
        gameID = UUID() // Обновляем gameID для пересоздания сцены
    }
}

class GameAiClass: SKScene {
    private let boardSize: Int = 8
    private let checkerSize: CGFloat = 40
    private var checkers: [SKSpriteNode] = []
    private var selectedChecker: SKSpriteNode?
    @Binding var currentPlayer: Int
    
    @AppStorage("player1Score") var player1Score = 0
    @AppStorage("player2Score") var player2Score = 0
    
    init(currentPlayer: Binding<Int>) {
        _currentPlayer = currentPlayer
        super.init(size: CGSize(width: 320, height: 320))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        backgroundColor = .lightGray
        setupBoard()
        setupCheckers()
    }
    
    private func setupBoard() {
        let cellSize = checkerSize
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                let cell = SKShapeNode(rect: CGRect(x: CGFloat(i) * cellSize, y: CGFloat(j) * cellSize, width: cellSize, height: cellSize))
                cell.strokeColor = .black
                cell.lineWidth = 1
                cell.fillColor = (i + j) % 2 == 0 ? .white : .darkGray
                addChild(cell)
            }
        }
    }
    
    private func setupCheckers() {
        let cellSize = checkerSize
        for col in 0..<boardSize {
            let isBlackRed = (col == 3)  // У красного на 4-й позиции (индекс 3) будет черная фишка
            let isBlackBlue = (col == 4) // У синего на 5-й позиции (индекс 4) будет черная фишка
            let redChecker = createChecker(named: isBlackRed ? "black" : "redOne",
                                           at: CGPoint(x: CGFloat(col) * cellSize + cellSize / 2, y: cellSize / 2))
            redChecker.name = isBlackRed ? "blackRed" : "redOne"
            addChild(redChecker)
            checkers.append(redChecker)
            let blueChecker = createChecker(named: isBlackBlue ? "black" : "blueOne",
                                            at: CGPoint(x: CGFloat(col) * cellSize + cellSize / 2, y: CGFloat(boardSize - 1) * cellSize + cellSize / 2))
            blueChecker.name = isBlackBlue ? "blackBlue" : "blueOne"
            addChild(blueChecker)
            checkers.append(blueChecker)
        }
    }
    
    private func createChecker(named imageName: String, at position: CGPoint) -> SKSpriteNode {
        let checker = SKSpriteNode(imageNamed: imageName)
        checker.size = CGSize(width: checkerSize, height: checkerSize)
        checker.position = position
        checker.physicsBody = SKPhysicsBody(circleOfRadius: checkerSize / 2)
        checker.physicsBody?.isDynamic = true
        checker.physicsBody?.allowsRotation = false
        return checker
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let checker = nodes(at: location).first(where: { $0.name == (currentPlayer == 1 ? "redOne" : "blueOne") }) as? SKSpriteNode {
            selectedChecker = checker
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedChecker = selectedChecker else { return }
        let location = touch.location(in: self)
        let dx = location.x - selectedChecker.position.x
        let dy = location.y - selectedChecker.position.y
        let direction = CGVector(dx: dx * 0.1, dy: dy * 0.1)
        selectedChecker.physicsBody?.applyImpulse(direction)
        self.selectedChecker = nil
        
        // Переключение хода на AI
        if currentPlayer == 1 {
            currentPlayer = 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.makeAiMove()
            }
        }
    }
    
    private func makeAiMove() {
        // Выбираем случайную синюю фишку
        guard let aiChecker = checkers.filter({ $0.name == "blueOne" }).randomElement() else { return }
        
        // Генерируем движение только вниз
        let dy = CGFloat.random(in: (-50)...(-10)) // Случайное значение в диапазоне от -50 до -10
        aiChecker.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dy * 0.1)) // Движение только вниз
        
        // Передаем ход обратно игроку
        currentPlayer = 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        var checkersToRemove: [SKSpriteNode] = []
        for checker in checkers {
            if checker.position.x < -checkerSize || checker.position.x > frame.width + checkerSize ||
               checker.position.y < -checkerSize || checker.position.y > frame.height + checkerSize {
                
                checkersToRemove.append(checker)
                if checker.name == "redOne" {
                    player2Score += 1
                } else if checker.name == "blueOne" {
                    player1Score += 1
                }
                
                // Логика выбивания черной фишки
                if checker.name == "blackRed" {
                    let redStillExists = checkers.contains { $0.name == "redOne" }
                    if redStillExists {
                        // Если у красного есть еще фишки → он проиграл
                        player2Score = 8
                    } else {
                        // Черная была последней → Player 1 выигрывает
                        player1Score = 8
                    }
                } else if checker.name == "blackBlue" {
                    let blueStillExists = checkers.contains { $0.name == "blueOne" }
                    if blueStillExists {
                        // Если у синего есть еще фишки → он проиграл
                        player1Score = 8
                    } else {
                        // Черная была последней → Player 2 выигрывает
                        player2Score = 8
                    }
                }
            }
        }
        for checker in checkersToRemove {
            checker.removeFromParent()
            checkers.removeAll { $0 == checker }
        }
    }
}


#Preview {
    GameAi()
}
