import ScreenSaver

class Matrix: ScreenSaverView {
  let font = NSFont(name: "Monaco", size: 14) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)
  
  var columns: Int {
    return Int(frame.width / font.pointSize)
  }
  
  var rows: Int {
    return Int(frame.height / font.pointSize)
  }
  
  var rect: NSRect {
    return NSRect(origin: .zero, size: NSSize(width: self.font.pointSize, height: frame.height))
  }
  
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
  
  var i = 0
  override func draw(_ rect: NSRect) {
    NSAttributedString(string: Array(repeating: "0", count: i).joined(separator: "\n"),
      attributes: [
        .backgroundColor: NSColor.red,
        .foregroundColor: NSColor.green,
        .font: self.font,
    ]).draw(in: self.rect)
    i+=1
  }
  
  override var isFlipped: Bool {
    return true
  }
  
  override var hasConfigureSheet: Bool {
    return true
  }
}
