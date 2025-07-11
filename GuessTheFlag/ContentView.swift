//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alonso Acosta Enriquez on 30/07/24.
//

import SwiftUI

struct ImageFlag: View {
    let country: String
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany",
        "Ireland", "Italy", "Nigeria",
        "Poland", "Spain", "UK",
        "Ukraine", "US"
    ].shuffled() // This allow to change the order and show different flags
    @State private var correctAnswer = Int.random(in: 0...2)
    // this properties will be set when a flag is tapped
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var isGameOver = false
    @State private var attempts = 0
    
    @State private var scale = 1.0
    @State private var opacity = 1.0
    @State private var tappedFlag = 0
    @State private var animationAmount = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            ).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            ImageFlag(country: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(
                                number == tappedFlag && number == correctAnswer
                                ? animationAmount
                                : 0
                            ),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(number != correctAnswer ? opacity : 1)
                        .scaleEffect(number != correctAnswer ? scale : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("OK", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $isGameOver) {
            Button("Play again", action: restartGame)
        } message: {
            Text("Your final score is \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        tappedFlag = number
        withAnimation() {
            animationAmount += 360
            opacity = 0.25
            scale = 0.75
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            attempts += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            attempts += 1
        }
        
        showingScore = true
        
        if attempts == 8 {
            isGameOver = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacity = 1
        scale = 1
    }
    
    func restartGame() {
        score = 0
        attempts = 0
    }
}

#Preview {
    ContentView()
}
