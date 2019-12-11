//
//  ViewController.swift
//  Matrix
//
//  Created by Chris Bailey on 12/10/19.
//  Copyright © 2019 baileyCode. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  var matrix = Matrix(frame: NSZeroRect, isPreview: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let matrix = Matrix(frame: view.bounds, isPreview: false) else { return }
    
    view.addSubview(matrix)
    matrix.animateOneFrame()
    matrix.draw(view.bounds)
    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

