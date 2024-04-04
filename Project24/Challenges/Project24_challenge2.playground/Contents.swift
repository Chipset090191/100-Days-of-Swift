import UIKit

let name = "pet"






extension String {
    var isNumeric:Bool {
        let numericRegex = try! NSRegularExpression(pattern: "^[0-9]+$")
        return numericRegex.firstMatch(in: self, range: NSRange(location: 0, length: self.utf16.count)) != nil
    }
}



//^: Asserts the start of the line.
//[0-9]: Represents a character class that matches any single digit from 0 to 9.
//+: Matches one or more occurrences of the preceding element, which in this case is [0-9].
//$: Asserts the end of the line.


name.isNumeric

"123m".isNumeric

