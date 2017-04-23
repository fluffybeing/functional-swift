//: Playground - noun: a place where people can play

import UIKit
import CoreImage

typealias Filter = (CIImage) -> (CIImage)



// Blur
func blur(radius: Double) -> Filter {
    
    return { image in
        let parameters: [String: Any] = [kCIInputRadiusKey: radius,
                          kCIInputImageKey: image]
        
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)
        return filter!.outputImage!
    }
}

// Color Generator
func colorGenerator(color: CIColor) -> Filter {
    
    return { _ in
        let parameters: [String: Any] = [kCIInputColorKey: color]
        let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
        return filter!.outputImage!
    }
}


// Composite filter
func compositeSourceOver(overlay: CIImage) -> Filter {
    
    return { image in
        let paramaters: [String: Any] = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        
        let filter = CIFilter(name: "CISourceOverCompositing" , withInputParameters: paramaters)
        let cropRect = image.extent
        return filter!.outputImage!.cropping(to: cropRect)
    }
}

// Color Overlay
func colorOverlay(color: CIColor) -> Filter {
    return { image in
        // first colorGenerator returns a filter function
        // and then we pass the image in it to get the image
        let overlayImage = colorGenerator(color: color)(image)
        // above line can be broken into below
        // let overlayFilter = colorGenerator(color: UIColor.green)
        // let overlayFilteredImage = overlayFilter(image)
        return compositeSourceOver(overlay: overlayImage)(image)
    }
}


// Using the filter API
//let url = URL(string: "http://tinyurl.com/m74sldb")
//let image = CIImage(contentsOf: url!)!
//
//
//let blurRadius = 5.0
//let overlayColor = CIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
//let blurredImage = blur(radius: blurRadius)(image)
//let overlaidImage = colorOverlay(color: overlayColor)(blurredImage)


// Composition
func composeFilter(filter1: @escaping Filter, filtet2: @escaping Filter) -> Filter {
    return { image in
        filtet2(filter1(image))
    }
}


infix operator >>> { associativity left }

func >>> (filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}


// Currying
func add1(x: Int, y: Int) -> Int {
    return x + y
}

func add2(x: Int) -> (Int -> Int) {
    return { y in
        return x + y
    }
}


add1(x: 5, y: 6)
add2(x: 5)(6)


