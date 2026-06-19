import SwiftUI

/// Replaces content with a skeleton placeholder while loading, preserving layout size.
public struct SkeletonModifier: ViewModifier {
    private let isLoading: Bool
    private let styleOverride: SkeletonStyle?
    private let shimmerActive: Bool

    @Environment(\.skeletonStyle) private var environmentStyle
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        isLoading: Bool,
        style: SkeletonStyle? = nil,
        shimmerActive: Bool = true
    ) {
        self.isLoading = isLoading
        self.styleOverride = style
        self.shimmerActive = shimmerActive
    }

    private var resolvedStyle: SkeletonStyle {
        styleOverride ?? environmentStyle
    }

    public func body(content: Content) -> some View {
        content
            .opacity(isLoading ? 0 : 1)
            .redacted(reason: isLoading && resolvedStyle.config.useRedactedStyle ? .placeholder : [])
            .overlay {
                if isLoading {
                    SkeletonPlaceholderOverlay(
                        style: resolvedStyle,
                        shimmerActive: shimmerActive && !shouldDisableShimmer
                    )
                    .mask(content)
                    .transition(.opacity)
                }
            }
            .animation(resolvedStyle.config.transition, value: isLoading)
            .accessibilityElement(children: isLoading ? .ignore : .contain)
            .accessibilityLabel(isLoading ? "Loading" : "")
    }

    private var shouldDisableShimmer: Bool {
        resolvedStyle.animation.respectsReduceMotion && reduceMotion
    }
}

/// Fills the available space with a skeleton base color and optional shimmer.
struct SkeletonPlaceholderOverlay: View {
    let style: SkeletonStyle
    let shimmerActive: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Rectangle()
            .fill(style.colors(for: colorScheme).base)
            .opacity(style.config.opacity)
            .overlay {
                if shimmerActive {
                    ShimmerView(active: true, style: style)
                }
            }
    }
}
