//
//  Person.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

import UIKit
import Foundation

public struct BoundingBox
{
    var width: CGFloat = 0
    var top: CGFloat = 0
    var height: CGFloat = 0
    var left: CGFloat = 0
    var gender: String?
    var emotion: Emotion?
    var ageRange: (Int, Int)?

    public init(width: Double?, top: Double?, height: Double?, left: Double?, gender: String?, emotion: String?, lowAgeEstimate: Int?, highAgeEstimate: Int?)
    {
        if let width = width, let top = top, let height = height, let left = left
        {
            self.width = CGFloat(width)
            self.top = CGFloat(top)
            self.height = CGFloat(height)
            self.left = CGFloat(left)
        }

        self.gender = gender

        if let low = lowAgeEstimate, let high = highAgeEstimate
        {
            self.ageRange = (low, high)
        }

        self.emotion = Emotion.neutral

        for value in Emotion.allValues
        {
            if emotion == value.rawValue
            {
                self.emotion = value
            }
        }
    }
}

// We're ignoring the confidence since API tends to be > 90% certainty...and this is a hackathon.
public enum Emotion: String
{
    case happy = "HAPPY"
    case sad = "SAD"
    case surprised = "SURPRISED"
    case confused = "CONFUSED"
    case neutral

    /// Does not include neutral as that acts as the default.
    static let allValues = [Emotion.happy,
                            Emotion.sad,
                            Emotion.surprised,
                            Emotion.confused]
}

extension Emotion: Equatable
{
    public static func == (lhs: Emotion, rhs: Emotion) -> Bool
    {
        return lhs.rawValue == rhs.rawValue
    }
}
