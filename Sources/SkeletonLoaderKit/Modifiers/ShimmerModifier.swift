import SwiftUI

/// Applies a moving shimmer gradient over the content, masked to its shape.
public struct ShimmerModifier: ViewModifier {
    private let active: Bool
    private let styleOverride: SkeletonStyle?

    @Environment(\.skeletonStyle) private var environmentStyle

    public init(active: Bool = true, style: SkeletonStyle? = nil) {
        self.active = active
        self.styleOverride = style
    }

    private var resolvedStyle: SkeletonStyle {
        styleOverride ?? environmentStyle
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if active {
                    ShimmerView(active: true, style: resolvedStyle)
                        .mask(content)
                }
            }
            .animation(resolvedStyle.config.transition, value: active)
    }
}
