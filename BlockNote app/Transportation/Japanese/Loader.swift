//
//  Loader.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//

import Foundation

class JMDictCoordinator: ObservableObject {
    /// file name
    let JMFileName = "jmdict-eng-3.5.0"
    /// number of elements to load per each
    let batchSize = 300
    
    /// async queue
    let JMDictqueue = DispatchQueue(label: "jmdict-queue", attributes: .concurrent)
    
    /// dictionary to store the loaded elements
    @Published var dictionary: [JMDictWord] = []
    
    /// get the japanese data asynchronously
    func getTheJapaneseData() {
        JMDictqueue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                guard let fileURL = Bundle.main.url(forResource: self.JMFileName, withExtension: "json") else {
                    print("JSON file not found")
                    return
                }
                
                // Reading the JSON file into data
                let fileContents = try Data(contentsOf: fileURL)
                
                // Parsing the JSON data into a Swift object
                let decoder = JSONDecoder()
                let json = try decoder.decode(JMDictionary.self, from: fileContents)
                
                // Iterating through the JSON elements and processing them
                var currentIndex = 0
                while currentIndex < json.words.count {
                    let endIndex = min(currentIndex + self.batchSize, json.words.count)
                    let elements = Array(json.words[currentIndex..<endIndex])
                    
                    DispatchQueue.main.async {
                        self.dictionary.append(contentsOf: elements)
                    }
                    
                    // Add a delay between each batch for better UI responsiveness
                    Thread.sleep(forTimeInterval: 0.5)
                    
                    // Updating the current index for the next iteration
                    currentIndex = endIndex
                }
                
                print("JSON processing completed")
            } catch {
                print("Error processing JSON file:", error)
            }
        }
    }
}
