
import UIKit


enum Encoding {
    case ASCII
    case NEXTSTEP
    case JapaneseEUC
    case UTF8
}

//let myEnoding = Encoding.ASCII + Encoding.UTF8 // error: binary operator '+' cannot be applied to two 'Encoding' operands

func toNSStringEncoding(encoding: Encoding) -> String.Encoding {
    switch encoding {
    case Encoding.ASCII:
        return String.Encoding.ascii
    case Encoding.JapaneseEUC:
        return String.Encoding.japaneseEUC
    case Encoding.NEXTSTEP:
        return String.Encoding.nextstep
    case Encoding.UTF8:
        return String.Encoding.utf8
    }
}

func createEncoding(enc: String.Encoding) -> Encoding? {
    switch enc {
    case String.Encoding.ascii:
        return Encoding.ASCII
    default:
        return nil
    }
}


func loacalizedEncodingName(encoding: Encoding) -> String {
    return String.localizedName(of: toNSStringEncoding(encoding: encoding))
}

// Associated Value
func readFile1(path: String, encoding: Encoding) -> String? {
    
    let mayBeString = try! NSString(contentsOfFile: path, encoding: toNSStringEncoding(encoding: encoding).rawValue)
    
    return mayBeString as String
}

enum ReadFileResult {
    case Sucess(String)
    case Failure(Error)
}

// Enums support generic
enum Result<T> {
    case Sucess(T)
    case Failure(Error)
}



let exampleSucees: ReadFileResult = ReadFileResult.Sucess("File Content Goes Here!")

func readFile(path: String, encoding: Encoding) -> Result<String> {
    do {
        let mayBeString = try! NSString(contentsOfFile: path, encoding: toNSStringEncoding(encoding: encoding).rawValue)
        return .Sucess(mayBeString as String)
    } catch let error {
        return .Failure(error)
    }
}


