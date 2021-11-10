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
    
    // current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    
    var styleData: Data?
    
    init() {
        
     getLocalData()
        
    }
    
    // MARK: - Data methods
    
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
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
                currentModuleIndex = index 
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
}
