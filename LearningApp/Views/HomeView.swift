//
//  ContentView.swift
//  LearningApp
//
//  Created by Franziska Werner on 22.10.21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView{
                    
                    LazyVStack {
                        
                        ForEach(model.modules){module in
                            
                            VStack (spacing: 20) {
                                    
                                NavigationLink(tag: module.id, selection: $model.currentSelectedContent) {
                                    ContentView()
                                        .onAppear {
                                            model.beginModule(module.id)
                                        }
                                } label: {
                                    HomeViewRow(image: module.content.image, description: module.content.description, duration: module.content.time, count: "\(module.content.lessons.count) Lessons", title: "Learn \(module.category)")
                                }

                                HomeViewRow(image: module.test.image, description: module.test.description, duration: module.test.time, count: "\(module.test.questions.count) Questions", title: "\(module.category) Test")
                            }
                        }
                    }
                    .accentColor(.black)
                }
            }
            .navigationTitle("Get Started")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
