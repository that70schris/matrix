import Cocoa

class ViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let matrix = Matrix(frame: view.bounds, isPreview: false) else { return }
    
    view.addSubview(matrix)
  }

}

  
