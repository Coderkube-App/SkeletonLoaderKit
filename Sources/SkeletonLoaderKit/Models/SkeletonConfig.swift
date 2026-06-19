import SwiftUI

/// Configuration for skeleton placeholder appearance and behavior.
public struct SkeletonConfig: Equatable, Sendable {
    public var cornerRadius: CGFloat
    public var opacity: Double
    public var transition: Animation
    public var useRedactedStyle: Bool

    public init(
        cornerRadius: CGFloat = 4,
        opacity: Double = 1.0,
        transition: Animation = .easeInOut(duration: 0.25),
        useRedactedStyle: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.transition = transition
        self.useRedactedStyle = useRedactedStyle
    }

    public static let `default` = SkeletonConfig()
}
