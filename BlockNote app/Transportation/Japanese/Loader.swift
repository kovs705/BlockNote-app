//
//  Loader.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//

import Foundation

class JMDictCoordinator {
    /// file name
    let JMFileName = "jmdict-eng-3.5.0"
    /// number of elements to load per each
    let batchSize = 300
    
    /// async queue
    let JMDictqueue = DispatchQueue(label: "jmdict-queue", attributes: .concurrent)
    
    /// calbback to reload cells
    var reloadCallback: ([JMDictWord]) -> Void
    var returnElementsIntoSet: ([JMDictWord]) -> Void
    
    init(reloadCallback: @escaping ([JMDictWord]) -> Void, returnElementsIntoSet: @escaping ([JMDictWord]) -> Void) {
        self.reloadCallback = reloadCallback
        self.returnElementsIntoSet = returnElementsIntoSet
    }
    
    /// get the japanese data asyncronously
    func getTheJapaneseData() {
        JMDictqueue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                guard let fileURL = Bundle.main.url(forResource: JMFileName, withExtension: "json") else {
                    print("JSON file not found")
                    return
                }
                
                // Reading the JSON file into data
                let fileContents = try Data(contentsOf: fileURL)
//                guard let fileContents = FileManager.default.contentsOfDirectory(atPath: path) else {
//                    print("Failed to read the JSON file")
//                    return
//                }
                
                // Parsing the JSON data into a Swift object
                guard let json = try JSONSerialization.jsonObject(with: fileContents, options: []) as? JMDictionary else {
                    print("Failed to parse the JSON data")
                    return
                }
                
                // Iterating through the JSON elements and processing them
                var currentIndex = 0
                while currentIndex < json.words.count {
                    
                    let endIndex = min(currentIndex + batchSize, json.words.count)
                    let elements = Array(json.words[currentIndex..<endIndex])
                    
//                    for element in elements {
//                        print(element)
//                    }
//                    Task {
//                        await returnElementsIntoSet(elements)
//                    }
                     
                    // Updating the current index for the next iteration
                    currentIndex = endIndex
                    
                    DispatchQueue.main.async {
                        print(elements)
                        self.reloadCallback(elements)
                    }
                    
                    // Add a delay between each batch for better UI responsiveness
                    Thread.sleep(forTimeInterval: 0.1)
                }
                
                print("JSON processing completed")
            } catch {
                print("Error processing JSON file:", error)
            }
        }
    }
}
