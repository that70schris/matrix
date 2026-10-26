import AppKit
import ScreenSaver

private enum MatrixPalette {
    static let background = NSColor(calibratedRed: 0.005, green: 0.018, blue: 0.012, alpha: 1)
    static let green = NSColor(calibratedRed: 0.18, green: 1.0, blue: 0.38, alpha: 1)
    static let bright = NSColor(calibratedRed: 0.78, green: 1.0, blue: 0.84, alpha: 1)
}

private struct RainColumn {
    var head: CGFloat
    var speed: CGFloat
    var length: Int
    var glyphs: [String]
    var phase: CGFloat
}

private enum MatrixMotion {
    static let speedRange: ClosedRange<CGFloat> = 5...15
    static let lengthRange: ClosedRange<Int> = 10...40
}

final class MatrixScreenSaverView: ScreenSaverView {
    private let glyphs = Array("日ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶﾑﾗｾﾈｽﾀﾇ012345789:・.=*+-<>|")
    private var columns: [RainColumn] = []
    private var lastTick: TimeInterval = 0
    private var font = NSFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    private var cellWidth: CGFloat = 14
    private var cellHeight: CGFloat = 19

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        configureAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAnimation()
    }

    private func configureAnimation() {
        animationTimeInterval = 1.0 / 120.0
        rebuildColumns()
    }

    override var isFlipped: Bool { true }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        rebuildColumns()
    }

    private func rebuildColumns() {
        guard bounds.width > 0, bounds.height > 0 else { return }
        let count = max(1, Int(ceil(bounds.width / cellWidth)))
        columns = (0..<count).map { _ in
            let rows = Int(bounds.height / cellHeight)
            return RainColumn(
                head: CGFloat(Int.random(in: -rows...rows)),
                speed: CGFloat.random(in: MatrixMotion.speedRange),
                length: Int.random(in: MatrixMotion.lengthRange),
                glyphs: (0..<(rows + 32)).map { _ in String(glyphs.randomElement()!) },
                phase: CGFloat.random(in: 0...1)
            )
        }
    }

    override func animateOneFrame() {
        let now = Date.timeIntervalSinceReferenceDate
        let delta = lastTick == 0 ? animationTimeInterval : min(now - lastTick, 0.1)
        lastTick = now
        let rows = CGFloat(bounds.height / cellHeight)
        for index in columns.indices {
            columns[index].head += columns[index].speed * CGFloat(delta)
            if columns[index].head - CGFloat(columns[index].length) > rows {
                columns[index].head = CGFloat.random(in: -CGFloat(columns[index].length)...(-2))
                columns[index].speed = CGFloat.random(in: MatrixMotion.speedRange)
                columns[index].length = Int.random(in: MatrixMotion.lengthRange)
                columns[index].phase = CGFloat.random(in: 0...1)
            }
            if Int.random(in: 0...18) == 0, !columns[index].glyphs.isEmpty {
                let slot = Int.random(in: 0..<columns[index].glyphs.count)
                columns[index].glyphs[slot] = String(glyphs.randomElement()!)
            }
        }
        setNeedsDisplay(bounds)
    }

    override func draw(_ rect: NSRect) {
        MatrixPalette.background.setFill()
        bounds.fill()

        for (columnIndex, column) in columns.enumerated() {
            let x = CGFloat(columnIndex) * cellWidth
            let headRow = Int(column.head)
            let firstRow = max(0, headRow - column.length)
            let lastRow = min(Int(bounds.height / cellHeight) + 1, headRow)
            guard firstRow <= lastRow else { continue }

            for row in firstRow...lastRow {
                let distance = headRow - row
                let fade = max(0.06, 1 - CGFloat(distance) / CGFloat(column.length))
                let isHead = distance == 0
                let color = isHead ? MatrixPalette.bright : MatrixPalette.green.withAlphaComponent(fade * 0.88)
                let glyphIndex = (row + Int(column.phase * 10)) % max(1, column.glyphs.count)
                let string = column.glyphs[glyphIndex]
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color,
                    .shadow: isHead ? NSShadow(matrixGlow: MatrixPalette.green) : NSShadow()
                ]
                string.draw(at: NSPoint(x: x, y: CGFloat(row) * cellHeight), withAttributes: attributes)
            }
        }
    }
}

private extension NSShadow {
    convenience init(matrixGlow color: NSColor) {
        self.init()
        shadowColor = color.withAlphaComponent(0.9)
        shadowBlurRadius = 9
        shadowOffset = .zero
    }
}
