import ScreenSaver

class Matrix: ScreenSaverView {
  var j: Int = 0
  let font = NSFont(name: "Monaco", size: 44) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
    animationTimeInterval = 1
  }
  
  override func animateOneFrame() {
    needsDisplay = true
  }
  
  override func draw(_ rect: NSRect) {
    NSAttributedString(string: "\(self.j)",
      attributes: [
        .backgroundColor: NSColor.red,
        .foregroundColor: NSColor.green,
        .font: self.font,
    ]).draw(at: NSPoint(x: 0, y: self.j * Int(self.font.pointSize)))
    self.j += 1
  }
  
  override var isFlipped: Bool {
    return true
  }
  
  override var hasConfigureSheet: Bool {
    return true
  }
}
