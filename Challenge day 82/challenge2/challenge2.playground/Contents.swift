import UIKit

extension Int {
    func times(_ closure: ()-> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

var t = 5

t.times {
  print(t)
}



