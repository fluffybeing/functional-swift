//: Playground - noun: a place where people can play

import UIKit


// MAP

// generic compute
func genericComputeArray<U>(xs: [Int], f: (Int) -> U) -> [U] {
    var result: [U] = []
    for x in xs {
        result.append(f(x))
    }
    return result
}

// custom map
func myMap<T, U>(xs: [T], f: (T) -> U) ->  [U] {
    var result: [U] = []
    for x in xs {
        result.append(f(x))
    }
    return result
}

// Swift map
func doubleArray3(xs: [Int]) -> [Int] {
    return xs.map { x in
        2 * x
    }
}

// FILTER

let exampleFiles = ["README.md", "HelloWorld.swift", "HelloSwift.swift", "FlappyBird.swift"]

func getSwiftFiles(files: [String]) -> [String] {
    var result: [String] = []
    
    for file in files {
        if file.hasSuffix(".swift") {
            result.append(file)
        }
    }
    return result
}

func myFilter<T>(xs: [T], check: (T) -> Bool) -> [T] {
    var result: [T] = []
    for x in xs {
        if check(x) {
            result.append(x)
        }
    }
    return result
}

// REDUCE
func sum(xs: [Int]) -> Int {
    var result: Int = 0
    
    for x in xs {
        result += x
    }
    return result
}

func concatenate(xs: [String]) -> String {
    var result: String = ""
    for x in xs {
        result += x
    }
    return result
}

// The initial Value
// combine function
func myReduce<A, R>(arr: [A], initialValue: R, combine: (R, A) -> R) -> R {
    var result = initialValue
    for i in arr {
        result = combine(result, i)
    }
    return result
}

func sumUsingReduce(xs: [Int]) -> Int {
    return myReduce(arr: xs, initialValue: 0) {
        result, x in result + x
    }
}

func flatten<T>(xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        result += xs
    }
    return result
}
