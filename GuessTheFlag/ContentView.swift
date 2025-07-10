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
    }
    
    func restartGame() {
        score = 0
        attempts = 0
    }
}

#Preview {
    ContentView()
}

/*
struct FlagImage: View {
    let countryId: Int
    let countries: [String]
    
    var body: some View {
        Image(countries[countryId])
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var attempts = 0
    @State private var finishedGame = false
    
    func resetGame() {
        score = 0
        attempts = 0
    }
    
    func flagTapped(_ number: Int) {
        if attempts == 8 {
            finishedGame = true
            return
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, That's the flag of \(countries[number])"
            score -= 1
        }
        
        if attempts < 8 {
            attempts += 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
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
                            FlagImage(countryId: number, countries: countries)
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Attempts: \(attempts)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over! :(", isPresented: $finishedGame) {
            Button("Continue") {  }
            Button("Restart", action: resetGame)
        } message: {
            Text("The game is over, your spent all your attempts. You can restart if you want to.")
        }
    }
}
 */
