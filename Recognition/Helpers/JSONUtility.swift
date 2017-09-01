//
//  JSONUtility.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class JSONUtility
{
    public static func getBoundingBoxes(completion: @escaping (([BoundingBox]) -> Void))
    {
        Alamofire.request(kProcessedImageURL).validate().responseJSON { response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                var boxes: [BoundingBox] = []

                if let faces = json["FaceDetails"].array
                {
                    for face in faces
                    {
                        boxes.append(BoundingBox(width: face["BoundingBox"]["Width"].doubleValue,
                                                 top: face["BoundingBox"]["Top"].doubleValue,
                                                 height: face["BoundingBox"]["Height"].doubleValue,
                                                 left: face["BoundingBox"]["Left"].doubleValue,
                                                 gender: face["Gender"]["Value"].stringValue,
                                                 emotion: face["Emotions"]["Type"].stringValue,
                                                 lowAgeEstimate: face["AgeRange"]["Low"].intValue,
                                                 highAgeEstimate: face["AgeRange"]["High"].intValue))
                    }

                    completion(boxes)
                }
                else
                {
                    print("Failed to get any boxes")
                    completion([])
                }

            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
}
