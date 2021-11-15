//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Franziska Werner on 11.11.21.
//

import SwiftUI
import AVKit // for video

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        // brackets to ensure that this gets evaluated first (before concatenated with "Constants.videoHostUrl") and finally being passed into the initializer for the url object
        // optional chaining, because it might be the case that "model.currentLesson" isn't set yet
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        
        VStack {
            
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // MARK: Description
            CodeTextView()
            
            
            // MARK: Button to next lesson
            if model.hasNextLesson() {
                Button {
                    // advance lesson
                    model.nextLesson()
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Next lesson \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
            }
            else {
                Button {
                    // advance lesson
                    model.currentSelectedContent = nil
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
