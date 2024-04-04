import UIKit

var arr = [1,5,6,12,100]


extension Array where Element:Comparable {
    mutating func remove(item:Element) {
         if let location = self.firstIndex(of: item) {
             remove(at: location)
         }
    }
}

arr.remove(item: 55)




