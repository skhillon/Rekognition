//
//  ResultViewController.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

public let goHomeSegue = "goHome"
import UIKit

class ResultViewController: BaseViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func dismiss(_ sender: Any)
    {
        performSegue(withIdentifier: goHomeSegue, sender: sender)
    }

    var image: UIImage?
    
    override func viewDidLoad()
    {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0

        imageView.contentMode = .scaleAspectFit
        imageView.image = image ?? #imageLiteral(resourceName: "Camera")
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
}
