//
//  ImageUtility.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

import UIKit
import Foundation

public class ImageUtility
{
    // MARK: - Properties
    private static let strokeWidth: CGFloat = 4.0

    public static func draw(boundingBoxes: [BoundingBox], on image: UIImage?) -> UIImage?
    {
        guard let image = image else { return nil }

        let imageSize = image.size

        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()

        image.draw(at: CGPoint.zero)

        context?.setLineWidth(strokeWidth)

        for box in boundingBoxes
        {
            let boxColor = getColorForEmotionIn(box)
            let xPos = box.left * imageSize.width
            let yPos = box.top * imageSize.height
            let width = box.width * imageSize.width
            let height = box.height * imageSize.height

            // Draw rectangles around face.
            let rectangle = CGRect(x: xPos, y: yPos, width: width, height: height)

            context?.setStrokeColor(boxColor.cgColor)
            context?.addRect(rectangle)
            context?.strokePath()

            // Setup to draw text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            // Draw age range.
            if let ageRange = box.ageRange
            {
                let textXPos = xPos + width / 6
                let textYPos = yPos - (height * 0.2)

                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: height / 4)
                label.text = "\(ageRange.0) - \(ageRange.1)"
                label.textColor = boxColor
                let boundingRect = CGRect(x: textXPos, y: textYPos, width: label.bounds.width, height: label.bounds.height)
                label.drawText(in: boundingRect)
            }

            // Draw gender.
            if let gender = box.gender
            {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: height / 4)

                if gender == "Male"
                {
                    label.text = "M"
                }
                else if gender == "Female"
                {
                    label.text = "F"
                }
                else
                {
                    label.text = "N/A"
                }

                let textXPos = xPos + width / 4.5
                let textYPos = yPos + (height * 1.2)

                label.textColor = boxColor
                let boundingRect = CGRect(x: textXPos, y: textYPos, width: label.bounds.width, height: label.bounds.height)
                label.drawText(in: boundingRect)
            }
        }

        let annotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return annotatedImage
    }

    private static func getColorForEmotionIn(_ box: BoundingBox) -> UIColor
    {
        if let emotion = box.emotion
        {
            switch emotion {
            case .happy:
                return .green
            case .surprised:
                return .red
            case .confused:
                return .yellow
            case .sad:
                return .blue
            default:
                // Netural
                return .gray
            }
        }

        return .gray
    }

}
