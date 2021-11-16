//
//  TestView.swift
//  LearningApp
//
//  Created by Franziska Werner on 15.11.21.
//

import SwiftUI
import CoreAudio

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack (alignment: .leading) {
                // Number of question
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
              
                // Answers
                ScrollView {
                    
                    VStack {
                        
                        ForEach(0..<model.currentQuestion!.answers.count, id:\.self) {index in
                            
                            Button {
                                // track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack {
                                    // Answer has not yet been submitted
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white) // inline if-statement
                                            .frame(height: 48)
                                    }
                                    else {
                                        // if an answer has been selected and submitted
                                        // User has selected the right answer: show a green background
                                        // Correct answer is displayed in green
                                        if (index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex) ||
                                            (index == model.currentQuestion!.correctIndex) {
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        }
                                        // User has selected the wrong answer: show a red background
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                        }
                                        // Right answer is displayed in green (implemented in first if-case)
                                        /*
                                         else if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                         }
                                         */
                                        // the remaining buttons (indices) show a white background
                                        else {
                                            RectangleCard(color: Color.white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    
                                    Text(model.currentQuestion!.answers[index])
                                    
                                    
                                }
                                .accentColor(.black)
                                .padding(.horizontal, 20)
                            }
                            .disabled(submitted)
                        }
                    }
                }
                
                
                // Submit Button
                
                Button {
                    // change state of submitted variable to true
                    submitted = true
                    
                    // increment numCorrect, when answer is correct
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    // TODO: check the answer
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                            
                        Text("Submit")
                            .bold()
                            .foregroundColor(Color.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)

                
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test has not loaded yet; this is the trigger for onAppear() method; need to be set in order to see the TestView!
            ProgressView()
        }
    }
}


