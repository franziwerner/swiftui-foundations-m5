//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Franziska Werner on 10.11.21.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var description: String
    var duration: String
    var count: String // lessons or questions
    var title: String
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            HStack{
                Image(image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 116, height: 116)
                
                Spacer()
                
                VStack (alignment: .leading, spacing: 10) {
                    
                    Text(title)
                        .font(.title2)
                        .bold()
                    
                    Text(description)
                        .font(.caption)
                    
                    HStack {
                        Image(systemName: "text.book.closed")
                        
                        Text(count)
                            .font(Font.system(size: 10))
                        
                        Image(systemName: "clock")
                        
                        Text(duration)
                            .font(Font.system(size: 10))
                        
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", description: "Understand the fundamentals of the Swift programming language.", duration: "3 hours", count: "20 lessons", title: "Learn Swift")
    }
}
