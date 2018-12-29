//
//  ViewController.swift
//  yolo-object-tracking
//
//  Created by Mikael Von Holst on 2017-12-19.
//  Copyright © 2017 Mikael Von Holst. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation
import Accelerate

class SSDViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var cameraView: UIView!
   
   let captureSession = AVCaptureSession()
//   var itemLock : [String] = []
   var items    : [String] = []
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   
      
      captureSession.sessionPreset = .photo
      guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
      
      guard let input =  try? AVCaptureDeviceInput(device: captureDevice) else {return}
      
      captureSession.addInput(input)
      captureSession.startRunning()
      let previewLayer = AVCaptureVideoPreviewLayer( session: captureSession)
      view.layer.addSublayer(previewLayer)
      previewLayer.frame = view.frame
      
      let dataOutput = AVCaptureVideoDataOutput()
      dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
      captureSession.addOutput(dataOutput)
   }
   
   func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
      guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
      guard let model = try? VNCoreMLModel(for: FoodModel().model) else {return}
      let request = VNCoreMLRequest(model: model) { (finshedReq, err) in
         
         guard let results = finshedReq.results as? [VNClassificationObservation] else {return}
         guard let firstObservation = results.first else {return}
         
         print(firstObservation.identifier, firstObservation.confidence)
         DispatchQueue.main.sync {
         if firstObservation.confidence > 0.75 && !self.view.subviews.contains(self.popUpView) && !self.items.contains(firstObservation.identifier.lowercased()) && self.itemLockLabel.text != firstObservation.identifier{
               self.animateIn(item: firstObservation.identifier)
            }
         }
         
         
         
      }
      try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
   }
   
   //***********************************************************
   @IBOutlet var popUpView: UIView!
   @IBOutlet weak var itemLockLabel: UILabel!
   
   func animateIn( item: String ){
//      self.itemLock.append(item)
      itemLockLabel.text = item
      self.popUpView.layer.cornerRadius = 10
      self.view.addSubview(popUpView)


      popUpView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
      
      popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      popUpView.alpha = 0
      
      UIView.animate(withDuration: 0.4){
         self.popUpView.alpha = 1
         self.popUpView.transform = CGAffineTransform.identity
      }
   }
   
   func animateOut()  {
      UIView.animate(withDuration: 0.3, animations: {
         self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
         self.popUpView.alpha = 0
         
      }){(success :Bool) in
         self.popUpView.removeFromSuperview()
      }
   }
   @IBAction func yesBtnClicked(_ sender: Any) {

      self.items.append(itemLockLabel.text!.lowercased())
      IngredientsDataService.instance.addNewIngredient(ingredientStr: itemLockLabel.text!.lowercased())
      animateOut()
      
   }
   @IBAction func noButtonClicked(_ sender: Any) {
      animateOut()
      self.captureSession.startRunning()
   }
   
   @IBAction func closeButtonPressed(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
}

