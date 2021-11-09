//
//  ContentModel.swift
//  LearningApp
//
//  Created by Franziska Werner on 22.10.21.
//

import Foundation

// this is going to be our view model; controls all our views and has the data
class ContentModel: ObservableObject {
    
    // initialize into an empty array
    @Published var modules = [Module]()
    var styleData: Data?
    
    init() {
        
     getLocalData()
        
    }
    
    func getLocalData(){
        
        // get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do{
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch{
            print("Could not parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do{
            // Read file into data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch{
            print("Could not parse style data")
        }
        
        
    }
}
