import SwiftUI

/// A reusable shimmer overlay driven by a moving linear gradient.
public struct ShimmerView: View {
    private let style: SkeletonStyle
    private let active: Bool

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false

    public init(active: Bool = true, style: SkeletonStyle = .default) {
        self.active = active
        self.style = style
    }

    public var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: style.colors(for: colorScheme).base, location: 0),
                .init(color: style.colors(for: colorScheme).highlight.opacity(style.gradientOpacity + 0.2), location: 0.45),
                .init(color: style.colors(for: colorScheme).highlight, location: 0.5),
                .init(color: style.colors(for: colorScheme).highlight.opacity(style.gradientOpacity + 0.2), location: 0.55),
                .init(color: style.colors(for: colorScheme).base, location: 1)
            ]),
            startPoint: style.animation.direction.startPoint,
            endPoint: style.animation.direction.endPoint
        )
        .offset(
            x: style.animation.direction.isVertical ? 0 : animatedOffset,
            y: style.animation.direction.isVertical ? animatedOffset : 0
        )
        .opacity(active ? 1 : 0)
        .onAppear(perform: updateAnimation)
        .onChange(of: active) { _ in updateAnimation() }
        .onChange(of: reduceMotion) { _ in updateAnimation() }
    }

    private var animatedOffset: CGFloat {
        isAnimating ? 200 : -200
    }

    private var shouldAnimate: Bool {
        active && !(style.animation.respectsReduceMotion && reduceMotion)
    }

    private func updateAnimation() {
        guard shouldAnimate else {
            isAnimating = false
            return
        }
        isAnimating = false
        withAnimation(
            .linear(duration: style.animation.duration)
                .repeatForever(autoreverses: false)
        ) {
            isAnimating = true
        }
    }
}
