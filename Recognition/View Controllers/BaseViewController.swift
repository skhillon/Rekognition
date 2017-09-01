//
//  AWSNetworking.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

import Foundation
import AWSS3

public let showResultSegue = "showResultSegue"

enum JPEGQuality: CGFloat
{
    case highest = 1.0
    case high = 0.75
    case medium = 0.5
    case low = 0.25
}

class BaseViewController: UIViewController
{
    // MARK: - Properties
    let transferUtility = AWSS3TransferUtility.default()
    var baseImage: UIImage?
    var annotatedImage: UIImage?

    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?

    // MARK: - Error Handling
    func showErrorAlert(_ title: String, message: String = "Error")
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Upload Functionality
    func upload(image: UIImage)
    {
        let expression = AWSS3TransferUtilityUploadExpression()
        guard let imageData = UIImageJPEGRepresentation(image, JPEGQuality.medium.rawValue) else
        {
            showErrorAlert("Upload failed", message: "Could not upload as image was missing.")
            return
        }
        
        expression.progressBlock = progressBlock

        transferUtility.uploadData(
            imageData,
            bucket: kBucketName,
            key: kUploadKeyName,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    //self.statusLabel.text = "Failed"
                }

                if let _ = task.result {
                    //self.statusLabel.text = "Generating Upload File"
                    print("Upload Starting!")
                    // Do something with uploadTask.
                }

                return nil;
        }
    }

    func annotateImage(completion: @escaping (UIImage?) -> Void)
    {
        sleep(5) // I know this is terrible, give me a break it's a hackathon.

        JSONUtility.getBoundingBoxes { boxes in
            completion(ImageUtility.draw(boundingBoxes: boxes, on: self.baseImage))
        }
    }
}
