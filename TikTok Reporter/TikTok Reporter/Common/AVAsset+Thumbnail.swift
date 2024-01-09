//
//  AVAsset+Thumbnail.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import UIKit
import AVFoundation

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {

        DispatchQueue.global().async {

            let imageGenerator = AVAssetImageGenerator(asset: self)

            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]

            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
