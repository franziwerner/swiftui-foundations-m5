//
//  CodeTextView.swift
//  LearningApp
//
//  Created by Franziska Werner on 11.11.21.
//

import SwiftUI

// protocol here is: UIViewRepresentable for using UIKit functionality
struct CodeTextView: UIViewRepresentable {
   
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = false
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        // Set attributed text for the lesson
        textView.attributedText = model.codeText
        // Scroll back to the top: when next lesson is tapped (to have the text from the beginning)
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
