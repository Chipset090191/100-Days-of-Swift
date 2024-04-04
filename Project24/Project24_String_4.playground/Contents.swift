import UIKit

let input = "Swift is like Objective-C without the C"
input.contains("Swift")


let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
        
    }
}


// both code are below have the same work!
input.containsAny(of: languages)
languages.contains(where: input.contains)
