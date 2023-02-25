//
//  ContentView.swift
//  GuessTheFlag
//
//  Course: 100 days of SwiftUI
//  Taught by Paul Hudson
//  Created by Lucas Lumertz on 22/02/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOverAlert = false
    
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    private let maxQuetions = 8

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundColor(.white)
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: continueGame)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Game Over!", isPresented: $gameOverAlert) {
            Button("Restart", action: {
                restartGame()
                askQuestion()
            })
        } message: {
            Text("Your final score is \(score)")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else if number !=  correctAnswer && score == 0 {
            scoreTitle = "Wrong! That's the flag of \(countries[correctAnswer])"
            score = score
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[correctAnswer])"
            score -= 1
        }

        showingScore = true
    }
    
    func continueGame() {
        questionCount += 1
        
        if questionCount < maxQuetions {
            askQuestion()
        } else {
            gameOverAlert = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        questionCount = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

