import UIKit

let name = "this\nis\na\ntest"




name.components(separatedBy: " ")


extension String {
    var lines:[String] {
        return self.components(separatedBy: "\n")
    }
}

print (name.lines)
