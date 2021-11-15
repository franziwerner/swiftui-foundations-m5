//
//  TestView.swift
//  LearningApp
//
//  Created by Franziska Werner on 15.11.21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack {
                // Number of question
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                // Answers
                
                // Button
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test has not loaded yet; this is the trigger for onAppear method; need to be set!
            ProgressView()
        }
    }
}


