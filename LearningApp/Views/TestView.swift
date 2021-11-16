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
    
    // computed property
    var buttonText:String {
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // This is the last question
                return "Finish"
            }
            else {
                // There is a next question
                return "Next"
            }
        }
        else {return "Submit"}
    }
    
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
                    /* two branches for the action: in case, submitted is still false, a button click will cause the program to jump into the else brackets and perform the action that is written there; tapping on the button sets submitted to true, why the action wihtin the if-statement is performed by tapping the button once again */
                    // check if answer has been submitted
                    if submitted == true {
                        
                        model.nextQuestion()
                        
                        // Reset properties
                        selectedAnswerIndex = nil
                        submitted = false
                    }
                    else {
                        // submit the answer
                    
                        // change submitted state to true
                        submitted = true
                        
                        // check the answer and increment the counter numCorrect if answer is correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                            
                        Text(buttonText)
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
            TestResultView(numCorrect: numCorrect)
            
            // Test has not loaded yet; this is the trigger for onAppear() method; need to be set in order to see the TestView!
            //ProgressView()
        }
    }
}


