import SwiftUI

/// Adaptive color pair for skeleton base and highlight in light/dark mode.
public struct SkeletonColors: Equatable, Sendable {
    public var base: Color
    public var highlight: Color

    public init(base: Color, highlight: Color) {
        self.base = base
        self.highlight = highlight
    }

    public static let light = SkeletonColors(
        base: Color(white: 0.88),
        highlight: Color(white: 0.96)
    )

    public static let dark = SkeletonColors(
        base: Color(white: 0.22),
        highlight: Color(white: 0.32)
    )

    public static let adaptive = SkeletonColors(
        base: Color(red: 0.90, green: 0.91, blue: 0.92),
        highlight: Color(red: 0.96, green: 0.97, blue: 0.98)
    )
}

/// Complete styling for skeleton placeholders and shimmer overlays.
public struct SkeletonStyle: Equatable, Sendable {
    public var colors: SkeletonColors
    public var config: SkeletonConfig
    public var animation: AnimationConfig
    public var gradientOpacity: Double

    public init(
        colors: SkeletonColors = .adaptive,
        config: SkeletonConfig = .default,
        animation: AnimationConfig = .default,
        gradientOpacity: Double = 0.6
    ) {
        self.colors = colors
        self.config = config
        self.animation = animation
        self.gradientOpacity = gradientOpacity
    }

    public static let `default` = SkeletonStyle()

    public static let subtle = SkeletonStyle(
        colors: SkeletonColors(
            base: Color.primary.opacity(0.06),
            highlight: Color.primary.opacity(0.12)
        ),
        gradientOpacity: 0.4
    )

    public func colors(for colorScheme: ColorScheme) -> SkeletonColors {
        guard colors == .adaptive else { return colors }
        return colorScheme == .dark ? .dark : .light
    }
}
