import UIKit

public final class SCSiriWaveformView: UIView {
    public var waveColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }

    public var primaryWaveLineWidth: CGFloat = 3 {
        didSet { setNeedsDisplay() }
    }

    public var secondaryWaveLineWidth: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }

    public var idleAmplitude: CGFloat = 0.01

    private var level: CGFloat = 0
    private var phase: CGFloat = 0

    public func update(withLevel level: CGFloat) {
        self.level = min(max(level, 0), 1)
        phase += 0.18
        setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let midY = rect.midY
        let width = rect.width
        let amplitude = max(level, idleAmplitude) * midY * 0.9
        let frequency: CGFloat = 1.5

        for (index, lineWidth) in [primaryWaveLineWidth, secondaryWaveLineWidth, secondaryWaveLineWidth].enumerated() {
            let attenuation = 1 - (CGFloat(index) * 0.22)
            let progressPhase = phase + CGFloat(index) * .pi / 3
            let path = UIBezierPath()
            path.lineWidth = lineWidth

            var firstPoint = true
            stride(from: CGFloat.zero, through: width, by: 1).forEach { x in
                let normalizedX = (x / width) * 2 - 1
                let scaling = 1 - pow(normalizedX, 2)
                let y = scaling * amplitude * attenuation * sin((normalizedX * frequency * .pi) - progressPhase) + midY
                let point = CGPoint(x: x, y: y)
                if firstPoint {
                    path.move(to: point)
                    firstPoint = false
                } else {
                    path.addLine(to: point)
                }
            }

            context.saveGState()
            waveColor.withAlphaComponent(index == 0 ? 1 : 0.35).setStroke()
            path.stroke()
            context.restoreGState()
        }
    }
}
