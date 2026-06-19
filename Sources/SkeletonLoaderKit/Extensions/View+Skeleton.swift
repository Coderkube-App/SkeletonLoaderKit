import SwiftUI

public extension View {

    /// Applies a skeleton placeholder over this view while `isLoading` is true.
    ///
    /// The original view remains in the layout hierarchy so size and spacing are preserved.
    /// Content is masked and replaced with a shimmer skeleton during loading.
    ///
    /// ```swift
    /// Text("Loading content...")
    ///     .skeleton(isLoading: true)
    /// ```
    func skeleton(
        isLoading: Bool,
        style: SkeletonStyle? = nil,
        shimmerActive: Bool = true
    ) -> some View {
        modifier(SkeletonModifier(
            isLoading: isLoading,
            style: style,
            shimmerActive: shimmerActive
        ))
    }

    /// Applies a shimmer gradient animation over this view.
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: 8)
    ///     .fill(Color.gray.opacity(0.2))
    ///     .shimmer(active: true)
    /// ```
    func shimmer(
        active: Bool = true,
        style: SkeletonStyle? = nil
    ) -> some View {
        modifier(ShimmerModifier(active: active, style: style))
    }

    /// Configures skeleton styling for downstream modifiers.
    func skeletonStyle(_ style: SkeletonStyle) -> some View {
        environment(\.skeletonStyle, style)
    }
}

// MARK: - Environment

private struct SkeletonStyleKey: EnvironmentKey {
    static let defaultValue = SkeletonStyle.default
}

public extension EnvironmentValues {
    var skeletonStyle: SkeletonStyle {
        get { self[SkeletonStyleKey.self] }
        set { self[SkeletonStyleKey.self] = newValue }
    }
}

// MARK: - Layout Helpers

public extension View {

    /// Builds a vertical stack of skeleton rows, useful for list placeholders.
    func skeletonList(
        rowCount: Int,
        rowHeight: CGFloat = 72,
        spacing: CGFloat = 12,
        style: SkeletonStyle = .default
    ) -> some View {
        VStack(spacing: spacing) {
            ForEach(0..<rowCount, id: \.self) { _ in
                SkeletonView(
                    .roundedRectangle(cornerRadius: style.config.cornerRadius),
                    style: style
                )
                .frame(height: rowHeight)
            }
        }
    }
}

// MARK: - Preview Helpers

#if DEBUG
public extension View {

    /// Wraps the view in a preview container toggling between loading and loaded states.
    func skeletonPreview(
        isLoading: Bool = true,
        style: SkeletonStyle = .default
    ) -> some View {
        skeleton(isLoading: isLoading, style: style)
            .padding()
    }
}

public struct SkeletonPreviewGallery: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Skeleton Preview Gallery")
                    .font(.title2.bold())

                HStack(spacing: 12) {
                    SkeletonView(.circle)
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonView(.roundedRectangle(cornerRadius: 4))
                            .frame(height: 14)
                        SkeletonView(.roundedRectangle(cornerRadius: 4))
                            .frame(width: 120, height: 14)
                    }
                }

                SkeletonView(.roundedRectangle(cornerRadius: 8))
                    .frame(height: 160)
            }
            .padding(.horizontal)
        }
    }
}

struct SkeletonPreviewGallery_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonPreviewGallery()
    }
}
#endif
