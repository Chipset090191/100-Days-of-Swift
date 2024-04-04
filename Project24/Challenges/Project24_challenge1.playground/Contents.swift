import UIKit

let name = "pet"


extension String {
    func withPrefix(_ prefix:String) -> String {
        guard !self.hasPrefix(prefix) else {  return self }
        return self + prefix
    }
}

name.withPrefix("Alex")




