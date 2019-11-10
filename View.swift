import ScreenSaver

class Matrix: ScreenSaverView {

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    let hello: NSString = "hello SWIFT screen saver plugin"
    hello.draw(at: .zero, withAttributes: [
      .foregroundColor: NSColor.green,
      .font: NSFont(name: "Monaco", size: 14) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .medium),
    ])
  }
  
}
