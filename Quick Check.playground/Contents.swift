
import UIKit

func plusIsCommutative(x: Int, y: Int) -> Bool {
    return x + y == y + x
}

func minusIsCommutative(x: Int, y: Int) -> Bool {
    return x - y == y - x
}

// Generating Random Values
protocol Arbitrary {
    static func arbitrary() -> Self
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        let asciiCapitalCaseLetterRandom = arc4random_uniform(36) + 55
        return Character(UnicodeScalar(asciiCapitalCaseLetterRandom)!)
    }
    
    func smaller() -> Character? {return nil}
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: CGFloat(arc4random() % 50), height: CGFloat(arc4random() % 60))
    }
}


// MARK: String
func tabulate<A>(times: Int, f: (Int) -> A) -> [A] {
    return Array(0..<times).map(f)
}

func random(from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to - from))
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = random(from: 0, to: 40)
        let randomCharacters = tabulate(times: randomLength) { _ in
            Character.arbitrary()
        }
        return randomCharacters.reduce("") { $0 + String($1)}
    }
}
String.arbitrary()

// MARK: Check
func check1<A: Arbitrary>(message: String, prop: (A) -> Bool)  {
    let numberOfIterations = 10
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        if !prop(value) {
            print("\"\(message)\" doesn't hold: \(value)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}

func area(size: CGSize) -> CGFloat {
    return size.width * size.height
}

check1(message: "Area should be atleast 0") {size in
    area(size: size) >= 0}

check1(message: "Every String start with Hello") { (s: String) in
    s.hasPrefix("Hello")
}


// MARK: Smaller
protocol Smaller {
    func smaller() -> Self?
}

extension Int: Smaller {
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}

extension String: Smaller {
    func smaller() -> String? {
        return isEmpty ? nil : String(self.characters.dropFirst())
    }
}

// Arrays
func quickSort(array: [Int]) -> [Int] {
    var array = array
    
    if array.isEmpty {return []}
    
    let pivot = array.remove(at: 0)
    let lesser = array.filter { $0 < pivot }
    let greater = array.filter { $0 >= pivot }
    
    return quickSort(array: lesser) + Array([pivot]) + quickSort(array: greater)
    
}
