//
//  ViewController.swift
//  PenckilKitProject
//
//  Created by Micah Burnside on 6/7/22.
//

import UIKit
import PencilKit
import PhotosUI

class ViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var takeScreenshotBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var pencilBarButtonItem: UIBarButtonItem!
    
    let canvasWidth: CGFloat = 768
    let canvasOverscrollingHeight: CGFloat = 500
    var drawing = PKDrawing()
    let toolPicker = PKToolPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        if let window = parent?.view.window {
           toolPicker.setVisible(true, forFirstResponder: canvasView)
           toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        updateContentSizeForDrawing()
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }
    
    @IBAction func saveImagePressed(_ sender: UIBarButtonItem) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: image!)}, completionHandler: {success, error in
                // deal with success
                
            })
        }
    }
    
    @IBAction func selectStylusType(_ sender: UIBarButtonItem) {
        canvasView.allowsFingerDrawing.toggle()
        pencilBarButtonItem.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        updateContentSizeForDrawing()
    }
    
    func updateContentSizeForDrawing() {
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollingHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }
    
}

