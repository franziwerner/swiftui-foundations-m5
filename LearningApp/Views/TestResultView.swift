//
//  TestResultView.swift
//  LearningApp
//
//  Created by Franziska Werner on 16.11.21.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var numCorrect: Int
    
    // optional property
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome!"
        }
        else if pct > 0.2 {
            return "Doing well!"
        }
        else {
            return "Keep learning!"
        }
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text(resultHeading)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Spacer()
            
            Button {
                model.currentSelectedTest = nil
            } label: {
                
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
    }
}

