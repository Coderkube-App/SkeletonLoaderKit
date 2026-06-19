# SkeletonLoaderKit

A lightweight, reusable SwiftUI package that provides elegant skeleton loading placeholders with shimmer effects to improve perceived performance in iOS applications.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-green.svg)](https://developer.apple.com/xcode/swiftui/)

## Features

- **Skeleton Views** — Rectangle, Circle, Rounded Rectangle, and custom `Shape` support
- **Shimmer Animation** — Smooth gradient shimmer with configurable speed and direction
- **Easy Modifiers** — `.skeleton(isLoading:)`, `.shimmer(active:)`, `.skeletonStyle(...)`
- **Adaptive Styling** — Light/dark mode support with customizable colors and gradients
- **Layout Friendly** — Works with `List`, `LazyVStack`, `ScrollView`, and complex layouts
- **Accessibility** — Respects Reduce Motion settings
- **Performance** — Timeline-driven animations with minimal redraw overhead
- **Redacted Integration** — Optional `.redacted(reason: .placeholder)` support

## Requirements

| Requirement | Version |
|-------------|---------|
| iOS         | 15.0+   |
| macOS       | 12.0+   |
| tvOS        | 15.0+   |
| watchOS     | 8.0+    |
| Swift       | 5.9+    |
| Xcode       | 15.0+   |

## Installation

### Swift Package Manager

Add SkeletonLoaderKit to your project via Xcode:

1. **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/your-username/SkeletonLoaderKit.git
   ```
3. Select the version rule and add the `SkeletonLoaderKit` library to your target.

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SkeletonLoaderKit.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["SkeletonLoaderKit"]
    )
]
```

## Quick Start

Import the package and apply skeleton modifiers to any SwiftUI view:

```swift
import SwiftUI
import SkeletonLoaderKit

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Loading content...")
                .font(.title2)
                .skeleton(isLoading: isLoading)

            Image(systemName: "person.circle")
                .font(.system(size: 64))
                .skeleton(isLoading: isLoading)
        }
        .padding()
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation { isLoading = false }
        }
    }
}
```

## Integration Examples

Copy-paste examples for binding SkeletonLoaderKit into your app.

### MVVM Binding (Recommended)

Bind `isLoading` from your ViewModel:

```swift
import SwiftUI
import SkeletonLoaderKit

// MARK: - ViewModel

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var name = ""
    @Published var title = ""
    @Published var avatarSystemName = "person.circle"

    func load() async {
        isLoading = true

        // Replace with your API call
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        name = "Jane Doe"
        title = "iOS Developer"
        avatarSystemName = "person.circle.fill"

        withAnimation(.easeInOut(duration: 0.25)) {
            isLoading = false
        }
    }
}

// MARK: - View

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: viewModel.avatarSystemName)
                .font(.system(size: 72))
                .skeleton(isLoading: viewModel.isLoading)

            Text(viewModel.name.isEmpty ? "Placeholder Name" : viewModel.name)
                .font(.title.bold())
                .skeleton(isLoading: viewModel.isLoading)

            Text(viewModel.title.isEmpty ? "Placeholder Title" : viewModel.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .skeleton(isLoading: viewModel.isLoading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .task {
            await viewModel.load()
        }
    }
}
```

### List / Feed Screen

```swift
import SwiftUI
import SkeletonLoaderKit

struct Post: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var posts: [Post] = []

    func load() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        posts = [
            Post(title: "SwiftUI Tips", subtitle: "Skeleton loaders improve UX"),
            Post(title: "iOS 15+", subtitle: "Works on older devices too"),
            Post(title: "SkeletonLoaderKit", subtitle: "Lightweight & reusable")
        ]

        withAnimation { isLoading = false }
    }
}

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        List {
            if viewModel.isLoading {
                ForEach(0..<5, id: \.self) { _ in
                    PostRowSkeleton()
                        .listRowSeparator(.hidden)
                }
            } else {
                ForEach(viewModel.posts) { post in
                    PostRow(post: post)
                }
            }
        }
        .listStyle(.plain)
        .task { await viewModel.load() }
    }
}

struct PostRow: View {
    let post: Post

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "photo")
                .font(.title)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 6) {
                Text(post.title).font(.headline)
                Text(post.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PostRowSkeleton: View {
    var body: some View {
        HStack(spacing: 12) {
            SkeletonView(.roundedRectangle(cornerRadius: 8))
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 8) {
                SkeletonView(.roundedRectangle(cornerRadius: 4))
                    .frame(height: 14)
                SkeletonView(.roundedRectangle(cornerRadius: 4))
                    .frame(width: 160, height: 12)
            }
        }
        .padding(.vertical, 4)
    }
}
```

### Bind to Existing Views

Use placeholder text so layout size stays correct while loading:

```swift
struct ArticleCard: View {
    let isLoading: Bool
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .skeleton(isLoading: isLoading)

            Text(title.isEmpty ? "Article title placeholder" : title)
                .font(.headline)
                .skeleton(isLoading: isLoading)

            Text("Subtitle placeholder text here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .skeleton(isLoading: isLoading)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
```

### Custom Style Binding

```swift
struct StyledSkeletonView: View {
    @State private var isLoading = true

    private let customStyle = SkeletonStyle(
        colors: .adaptive,
        config: SkeletonConfig(
            cornerRadius: 8,
            opacity: 0.9,
            transition: .easeInOut(duration: 0.3)
        ),
        animation: AnimationConfig(
            speed: 2.0,
            direction: .leftToRight,
            respectsReduceMotion: true
        )
    )

    var body: some View {
        VStack(spacing: 12) {
            Text("Custom shimmer style")
                .font(.title3)
                .skeleton(isLoading: isLoading)
        }
        .padding()
        .skeletonStyle(customStyle) // applies to all child .skeleton() calls
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isLoading = false }
            }
        }
    }
}
```

### View Extension Helper

```swift
extension View {
    func loadingSkeleton(_ isLoading: Bool) -> some View {
        self.skeleton(isLoading: isLoading, shimmerActive: true)
    }
}

// Usage
Text("Hello")
    .loadingSkeleton(viewModel.isLoading)
```

### Binding Checklist

| What to bind | How |
|---|---|
| Loading state | `@Published var isLoading` in ViewModel |
| Toggle after API | `withAnimation { isLoading = false }` |
| Per-view skeleton | `.skeleton(isLoading: viewModel.isLoading)` |
| Full list placeholder | `PostRowSkeleton()` while loading |
| App-wide style | `.skeletonStyle(.subtle)` on parent `VStack`/`List` |

## Usage Guide

### Basic Skeleton Modifier

Apply `.skeleton(isLoading:)` to mask any view with a shimmer placeholder while loading:

```swift
Text("Loading content...")
    .skeleton(isLoading: true)

Image(systemName: "person.circle")
    .skeleton(isLoading: true)
    .shimmer(active: true)
```

The original view stays in the layout hierarchy, so spacing and sizing are preserved.

### Standalone Skeleton Shapes

Build placeholder layouts that mirror your real UI:

```swift
// Preset shapes
SkeletonView(.rectangle)
    .frame(height: 20)

SkeletonView(.circle)
    .frame(width: 48, height: 48)

SkeletonView(.roundedRectangle(cornerRadius: 12))
    .frame(height: 120)

// Custom shape
SkeletonShapeView(shape: Capsule())
    .frame(width: 100, height: 32)
```

### Shimmer Only

Apply shimmer to any filled shape or view:

```swift
RoundedRectangle(cornerRadius: 8)
    .fill(Color.gray.opacity(0.15))
    .frame(height: 80)
    .shimmer(active: true)
```

### List & ScrollView Placeholders

```swift
ScrollView {
    if isLoading {
        VStack(spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonView(.circle)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonView(.roundedRectangle(cornerRadius: 4))
                            .frame(height: 12)
                        SkeletonView(.roundedRectangle(cornerRadius: 4))
                            .frame(width: 140, height: 12)
                    }
                }
            }
        }
        .padding()
    } else {
        LazyVStack {
            ForEach(items) { item in
                ItemRow(item: item)
            }
        }
    }
}
```

Or use the built-in helper:

```swift
Color.clear
    .skeletonList(rowCount: 5, rowHeight: 72, spacing: 12)
```

### MVVM Integration

```swift
@MainActor
final class FeedViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var posts: [Post] = []

    func load() async {
        isLoading = true
        posts = await api.fetchPosts()
        isLoading = false
    }
}

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        List(viewModel.posts) { post in
            PostRow(post: post)
                .skeleton(isLoading: viewModel.isLoading)
        }
        .task { await viewModel.load() }
    }
}
```

## Customization

### Skeleton Style

Configure colors, animation, and appearance with `SkeletonStyle`:

```swift
let customStyle = SkeletonStyle(
    colors: SkeletonColors(
        base: Color.gray.opacity(0.2),
        highlight: Color.white.opacity(0.5)
    ),
    config: SkeletonConfig(
        cornerRadius: 8,
        opacity: 0.9,
        transition: .easeInOut(duration: 0.3)
    ),
    animation: AnimationConfig(
        speed: 2.0,
        direction: .leftToRight,
        respectsReduceMotion: true
    ),
    gradientOpacity: 0.7
)

Text("Custom skeleton")
    .skeleton(isLoading: true, style: customStyle)
```

### Preset Styles

```swift
// Default adaptive style
.skeleton(isLoading: true, style: .default)

// Subtle, low-contrast placeholders
.skeleton(isLoading: true, style: .subtle)
```

### Shimmer Direction

```swift
let topToBottom = SkeletonStyle(
    animation: AnimationConfig(speed: 1.2, direction: .topToBottom)
)

SkeletonView(style: topToBottom)
    .frame(height: 100)
```

Available directions:

| Direction     | Description              |
|---------------|--------------------------|
| `leftToRight` | Horizontal, leading → trailing (default) |
| `rightToLeft` | Horizontal, trailing → leading |
| `topToBottom` | Vertical, top → bottom |

### Environment-Based Styling

Apply a style to a subtree of views:

```swift
VStack {
    Text("Title").skeleton(isLoading: isLoading)
    Text("Subtitle").skeleton(isLoading: isLoading)
}
.skeletonStyle(.subtle)
```

## API Reference

### Modifiers

| Modifier | Description |
|----------|-------------|
| `.skeleton(isLoading:style:shimmerActive:)` | Masks content with a skeleton placeholder |
| `.shimmer(active:style:)` | Adds a shimmer gradient overlay |
| `.skeletonStyle(_:)` | Sets the skeleton style via environment |
| `.skeletonList(rowCount:rowHeight:spacing:style:)` | Creates a vertical list of skeleton rows |

### Views

| View | Description |
|------|-------------|
| `SkeletonView` | Standalone skeleton with preset shapes |
| `SkeletonShapeView<S: Shape>` | Skeleton using a custom shape |
| `ShimmerView` | Reusable shimmer gradient layer |

### Models

| Type | Description |
|------|-------------|
| `SkeletonStyle` | Complete style configuration |
| `SkeletonConfig` | Corner radius, opacity, transitions |
| `AnimationConfig` | Shimmer speed, direction, reduce motion |
| `SkeletonColors` | Base and highlight colors |
| `SkeletonPreset` | `.rectangle`, `.circle`, `.roundedRectangle` |
| `ShimmerDirection` | Animation travel direction |

## Architecture

```
Sources/SkeletonLoaderKit/
├── Views/
│   ├── SkeletonView.swift      # Shape-based skeleton placeholders
│   └── ShimmerView.swift       # Core shimmer animation
├── Modifiers/
│   ├── SkeletonModifier.swift  # .skeleton() implementation
│   └── ShimmerModifier.swift   # .shimmer() implementation
├── Styles/
│   └── SkeletonStyle.swift     # Styling & color models
├── Extensions/
│   └── View+Skeleton.swift     # Public View extensions
├── Utils/
│   └── AnimationConfig.swift   # Animation configuration
└── Models/
    └── SkeletonConfig.swift    # Skeleton behavior config
```

The package follows a modular, protocol-oriented design:

- **Models** — Immutable configuration structs (`Sendable`, `Equatable`)
- **Views** — Composable skeleton and shimmer building blocks
- **Modifiers** — Drop-in integration for any `View`
- **Utils** — Shared animation logic

## Accessibility

SkeletonLoaderKit respects the system **Reduce Motion** setting. When enabled and `respectsReduceMotion` is `true` (default), shimmer animations are disabled and a static placeholder is shown instead.

Loading views are marked with an accessibility label of `"Loading"` and hide decorative skeleton elements from VoiceOver.

## Preview Helpers

Use built-in preview utilities during development:

```swift
#Preview {
    Text("Hello, World!")
        .skeletonPreview(isLoading: true)
}

#Preview {
    SkeletonPreviewGallery()
}
```

## Performance Tips

1. **Prefer modifiers on leaf views** — Apply `.skeleton()` to individual views rather than entire screens for finer-grained control.
2. **Use standalone skeletons for lists** — Pre-built `SkeletonView` layouts avoid rendering hidden content.
3. **Toggle `shimmerActive`** — Disable shimmer on off-screen placeholders if needed.
4. **Set `useRedactedStyle: false`** — Skip redacted styling when using custom skeleton overlays only.

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

---

Built with SwiftUI for iOS developers who care about perceived performance.
