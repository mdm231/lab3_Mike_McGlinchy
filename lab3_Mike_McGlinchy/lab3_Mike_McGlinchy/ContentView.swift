//
//  ContentView.swift
//  Partner Lab 3
//
//  Created by Mike McGlinchy on 10/28/25.
//

import SwiftUI

import Foundation

//card struct is the model
struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isCovered: Bool = true
}

//The view model
class GameViewModel: ObservableObject {
    // @Published automatically notifies the view of any changes.
    @Published var cards: [Card] = []
    
    //Initializes the view model and sets up initial cards
    init() {
        self.cards = createInitialCards()
    }

    //creates initial set of cards fot the game
    private func createInitialCards() -> [Card] {
        var initialCards: [Card] = []
        for index in 0..<12 {
            initialCards.append(Card(imageName: "flower\(index + 1)"))
        }
        return initialCards
    }

    func toggleCoveredState(for card: Card) {
        // Find the index of the tapped card.
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            // Modify the state directly.
            cards[index].isCovered.toggle()
        }
    }
}

//View that displays a single card
struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            // Back of the card
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .opacity(card.isCovered ? 0 : 1) // Hidden when covered
                .rotation3DEffect(.degrees(card.isCovered ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))

            // Front of the card (the gray cover)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .opacity(card.isCovered ? 1 : 0) // Visible when covered
                 //3-D rotation effect, simulates flipping
                .rotation3DEffect(.degrees(card.isCovered ? 0 : -180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
        .frame(width: 100, height: 100)
        .cornerRadius(10)
    }
}


struct ContentView: View {
    // @StateObject creates and owns the view model instance.
    @StateObject private var viewModel = GameViewModel()

    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            Text("Game")
                .font(.title)

            Spacer()

            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            // The view tells the view model about the user action.
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.toggleCoveredState(for: card)
                            }
                        }
                }
            }
            .padding()

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}





