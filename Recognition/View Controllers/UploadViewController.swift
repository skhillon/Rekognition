//
//  UploadViewController.swift
//  Recognition
//
//  Created by Sarthak Khillon on 8/30/17.
//  Copyright © 2017 Financial Engines. All rights reserved.
//

import UIKit
import AVFoundation

class UploadViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: - Storyboard outlets/actions
    @IBOutlet var progressView: UIProgressView!
    @IBAction private func uploadTapped(_ sender: Any)
    {
        showMenu()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        progressView.progress = 0.0

        progressBlock = { (task, progress) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = Float(progress.fractionCompleted)
                //self.statusLabel.text = "Uploading..."
            })
        }

        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error
                {
                    self.progressView.progressTintColor = .red
                    print("Failed with error: \(error)")
                }
                else if self.progressView.progress != 1.0
                {
                    self.progressView.progressTintColor = .red
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else
                {
                    self.progressView.progressTintColor = .green

                    self.annotateImage { image in
                        self.annotatedImage = image
                        self.performSegue(withIdentifier: showResultSegue, sender: nil)
                    }
                }
            })
        }
    }

    private func showMenu()
    {
        let menu = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Take Picture", style: .default) { _ in self.openCamera() }
        let photoLibraryAction = UIAlertAction(title: "Choose from Camera Roll", style: .default) { _ in self.chooseFromCameraRoll() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        menu.addAction(cameraAction)
        menu.addAction(photoLibraryAction)
        menu.addAction(cancelAction)

        present(menu, animated: true, completion: nil)
    }

    // MARK: - Image methods
    private func openCamera()
    {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized
        {
            takePicture()
        }
        else
        {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { authorized in
                if authorized
                {
                    self.takePicture()
                }
                else
                {
                    self.showErrorAlert("Please allow Recognition to use your camera in Privacy > Settings.")
                }
            }
        }
    }

    private func takePicture()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }

    private func chooseFromCameraRoll()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    // MARK: - Delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            baseImage = chosenImage
            upload(image: chosenImage)
        }
        else
        {
            showErrorAlert("We were unable to use this image. Sorry :(")
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultViewController
        {
            resultVC.image = annotatedImage
        }
    }
}
