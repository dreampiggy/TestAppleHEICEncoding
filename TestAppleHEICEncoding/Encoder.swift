//
//  Encoder.swift
//  TestAppleHEICEncoding
//
//  Created by lizhuoli on 2024/5/7.
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import ImageIO
import AVFoundation

@available(iOS 14.0, OSX 11.0, tvOS 14.0, watchOS 7.0, *)
extension Image {
    @inlinable init(platformImage: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: platformImage)
        #else
        self.init(uiImage: platformImage)
        #endif
    }
}

@available(iOS 14.0, OSX 11.0, tvOS 14.0, watchOS 7.0, *)
extension PlatformImage {
    static var empty = PlatformImage()
}

#if os(macOS)
@available(iOS 14.0, OSX 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformImage = NSImage
extension PlatformImage {
    var cgImage: CGImage? {
        var rect = NSMakeRect(0, 0, 0, 0)
        return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
#else
@available(iOS 14.0, OSX 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PlatformImage = UIImage
#endif

func loadImage(_ name: String) -> PlatformImage? {
    #if os(macOS)
    let image = Bundle.main.image(forResource: name)
    return image
    #else
    let path = Bundle.main.path(forResource: name, ofType: nil)!
    let image = PlatformImage(contentsOfFile: path)
    return image
    #endif
}

func encodeImage(_ image: PlatformImage) -> Data? {
    guard let cgImage = image.cgImage else {
        return nil
    }
    let result = NSMutableData()
    let uti = AVFileType.heic as CFString
    let destination = CGImageDestinationCreateWithData(result as CFMutableData, uti, 1, nil)!
    CGImageDestinationAddImage(destination, cgImage, nil)
    let success = CGImageDestinationFinalize(destination)

    return result as Data
}
