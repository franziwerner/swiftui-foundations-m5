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
    
    // current lesson; views that rely on that published property get automatically updated
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    @Published var lessonDescription = NSAttributedString()
    var styleData: Data?
    
    // to store current selected user content 
    @Published var currentSelectedContent:Int?
    
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
    
    func beginLesson(_ lessonIndex:Int) {
     
        // check whether the lesson index is within the range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            
            currentLessonIndex = lessonIndex
        }
        else {
            
            currentLessonIndex = 0
        }
        
        // set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        // set the current lesson description
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            return true
        }
        else {
            return false
        }
        
        /* short form:
         return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
         */
    }
    
    func nextLesson() {
        
        currentLessonIndex += 1
        
        // check whether currentLessonIndex is still smaller than module lesson count
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset lesson state
            currentLessonIndex = 0
            currentLesson = nil // because is an optional
        }
    }
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        // Technique 1: skips this block of code if it was not able to convert to attributed string and proceeds after block of code without throwing an error
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        // Technique 2: if it fails converting it will throw an error, so that you are able to respond to that error
        /*
        do {
            
                let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                resultString = attributedString
        }
        catch {
            print("Could not turn html into attributed string")
        }
        */
        
        return resultString
    }
    
}
