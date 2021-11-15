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
    // this keeps track of the lesson we are currently on
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // keeps track of the question we are currently on
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // to store current selected user content and test
    @Published var currentSelectedContent:Int?
    @Published var currentSelectedTest:Int?
    
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
        codeText = addStyling(currentLesson!.explanation)
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
    
    // because after tapping quiz button, we are going to see directly the first question and not a list of questions...
    // function needs to set the current module and the current question
    func beginTest(_ moduleID:Int) {
        
        // set the current modul
        beginModule(moduleID)
        
        //set the current question
        currentQuestionIndex = 0
        
        // if there are questions, set the current question to the first one 
        if currentModule?.test.questions.count ?? 0 > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextLesson() {
        
        currentLessonIndex += 1
        
        // check whether currentLessonIndex is still smaller than module lesson count
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
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
