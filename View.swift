import ScreenSaver

let font = NSFont(name: "Monaco", size: 14) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)

class Matrix: ScreenSaverView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  var lanes: Array<Lane> = []
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
    animationTimeInterval = 1
    
    let width = font.pointSize * (3/4)
    for i in 0...(Int(frame.width / width)) {
      lanes.append(Lane(NSRect(origin: NSPoint(x: CGFloat(i) * width, y: 0), size: frame.size)))
    }
    
  }
  
  override func animateOneFrame() {
    needsDisplay = true
  }
  
  override func draw(_ rect: NSRect) {
    lanes.forEach({ lane in
      lane.draw()
    })
  }
  
  override var isFlipped: Bool {
    return true
  }
  
  override var hasConfigureSheet: Bool {
    return true
  }
}

class Lane {
  var chars: [NSMutableAttributedString] = []
  var i = 0
  
  var frame: NSRect
  init(_ frame: NSRect) {
    self.frame = frame
    
    for _ in 0...(Int(frame.height / font.pointSize)) {
      chars.append(NSMutableAttributedString(
        string: " ",
        attributes: [
          .backgroundColor: NSColor.red,
          .foregroundColor: NSColor.green,
          .font: font,
        ]
      ))
    }
  }
  
  func draw() {
    guard chars.count > i else { return }
    var j: Int = 0
    
    self.chars[i].mutableString.setString("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!.description)
    self.chars.forEach({ char in
      char.draw(at: NSPoint(x: frame.minX, y: CGFloat(j) * font.pointSize))
      j+=1
    })
    
    i = i + 1 % chars.count
  }
}


