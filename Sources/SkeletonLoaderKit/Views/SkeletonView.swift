import SwiftUI

/// Predefined skeleton shape presets.
public enum SkeletonPreset: Equatable, Sendable {
    case rectangle
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
}

/// A standalone skeleton placeholder with optional shimmer.
public struct SkeletonView: View {
    private let preset: SkeletonPreset
    private let style: SkeletonStyle
    private let shimmerActive: Bool

    @Environment(\.colorScheme) private var colorScheme

    public init(
        _ preset: SkeletonPreset = .roundedRectangle(cornerRadius: 4),
        style: SkeletonStyle = .default,
        shimmerActive: Bool = true
    ) {
        self.preset = preset
        self.style = style
        self.shimmerActive = shimmerActive
    }

    public var body: some View {
        Group {
            switch preset {
            case .rectangle:
                skeletonContent(shape: Rectangle())
            case .circle:
                skeletonContent(shape: Circle())
            case .roundedRectangle(let cornerRadius):
                skeletonContent(
                    shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                )
            }
        }
        .accessibilityHidden(true)
    }

    private func skeletonContent<S: Shape>(shape: S) -> some View {
        shape
            .fill(style.colors(for: colorScheme).base)
            .opacity(style.config.opacity)
            .overlay {
                ShimmerView(active: shimmerActive, style: style)
                    .clipShape(shape)
            }
            .clipShape(shape)
    }
}

/// A skeleton placeholder using any custom `Shape`.
public struct SkeletonShapeView<S: Shape>: View {
    private let shape: S
    private let style: SkeletonStyle
    private let shimmerActive: Bool

    @Environment(\.colorScheme) private var colorScheme

    public init(
        shape: S,
        style: SkeletonStyle = .default,
        shimmerActive: Bool = true
    ) {
        self.shape = shape
        self.style = style
        self.shimmerActive = shimmerActive
    }

    public var body: some View {
        shape
            .fill(style.colors(for: colorScheme).base)
            .opacity(style.config.opacity)
            .overlay {
                ShimmerView(active: shimmerActive, style: style)
                    .clipShape(shape)
            }
            .clipShape(shape)
            .accessibilityHidden(true)
    }
}

/// Type-erased shape wrapper for internal clipping.
public struct AnyShape: Shape, @unchecked Sendable {
    private let pathBuilder: @Sendable (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    public func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}
