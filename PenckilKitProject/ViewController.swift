//
//  ViewController.swift
//  PenckilKitProject
//
//  Created by Micah Burnside on 6/7/22.
//

import UIKit
import PencilKit

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
    
    @IBAction func saveImagePressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func selectStylusType(_ sender: UIBarButtonItem) {
        
    }
    
}

