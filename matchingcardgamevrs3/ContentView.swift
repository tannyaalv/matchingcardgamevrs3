//
//  ContentView.swift
//  matchingcardgamevrs3
//
//  Created by Alvarez-Salsedo, Tanya on 4/24/24.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = UUID()
    var content: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

class GameViewModel: ObservableObject {
    @Published var board: [[Card]] = [[]]
    @Published var isGameOver: Bool = false

    init(difficulty: Difficulty) {
        // Initialize the game board based on the selected difficulty
        switch difficulty {
        case .easy:
            board = // Create board for easy difficulty
        case .medium:
            board = // Create board for medium difficulty
        case .difficult:
            board = // Create board for difficult difficulty
        }
    }
    func initializeGameBoard(difficulty: Difficulty) {
        let totalPairsCount = difficulty.totalPairsCount
        
        var contentArray: [String] = []
        for index in 0..<totalPairsCount {
            contentArray.append("Card \(index + 1)")
            contentArray.append("Card \(index + 1)")
        }
        
        contentArray.shuffle()
        
        var index = 0
        for row in 0..<boardSize.rows {
            var newRow: [Card] = []
            for col in 0..<boardSize.cols {
                let card = Card(content: contentArray[index])
                newRow.append(card)
                index += 1
            }
            board.append(newRow)
        }
    }

    var firstSelectedCard: Card?
    
    func selectCard(row: Int, col: Int) {
        guard !isGameOver else { return }
        // Implement logic to handle card selection
        let selectedCard = board[row][col]
        
        guard !selectedCard.isMatched && !selectedCard.isFaceUp else { return }
        
        if let firstCard = firstSelectedCard {
            if selectedCard.content == firstCard.content {
                selectedCard.isFaceUp = true
                selectedCard.isMatched = true
                firstCard.isMatched = true
                
                if isGameComplete() {
                    isGameOver = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    selectedCard.isFaceUp = false
                    firstCard.isFaceUp = false
                }
            }
            
            firstSelectedCard = nil
        } else {
            selectedCard.isFaceUp = true
            firstSelectedCard = selectedCard
        }
    }

    func checkForMatch(row: Int, col: Int) {
        // Implement logic to check for matching cards
    }

    func isGameComplete() -> Bool {
        // Implement logic to check if the game is complete
        for row in 0..<boardSize.rows {
            for col in 0..<boardSize.cols {
                if !board[row][col].isMatched {
                    return false

                }
            }
        }
        return true
    }
}

struct ContentView: View {
    @StateObject var viewModel = GameViewModel(difficulty: .easy)
    @State private var isGameStarted: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if isGameStarted {
                    GameBoardView(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: Button(action: {
                            isGameStarted = false
                        }) {
                            Text("Home")
                        })
                } else {
                    DifficultySelectionView(isGameStarted: $isGameStarted)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: EmptyView())
                }
            }
            .navigationBarTitle("Matching Card Game", displayMode: .inline)
        }
    }
}

struct GameBoardView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.board.indices, id: \.self) { row in
                HStack {
                    ForEach(viewModel.board[row].indices, id: \.self) { col in
                        CardView(card: $viewModel.board[row][col])
                            .padding(4)
                    }
                }
            }
        }
        .padding()
    }
}

struct CardView: View {
    @Binding var card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 50, height: 50) // Adjust size as needed

            if card.isFaceUp {
                Text(card.content)
            }
        }
        .onTapGesture {
            // Implement logic to handle card tap
        }
    }
}

struct DifficultySelectionView: View {
    @Binding var isGameStarted: Bool

    var body: some View {
        VStack {
            Text("Select Difficulty")
                .font(.title)
                .padding()

            Button("Easy") {
                isGameStarted = true
            }
            .padding()

            Button("Medium") {
                isGameStarted = true
            }
            .padding()

            Button("Difficult") {
                isGameStarted = true
            }
            .padding()
        }
    }
}

enum Difficulty {
    case easy, medium, difficult
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
