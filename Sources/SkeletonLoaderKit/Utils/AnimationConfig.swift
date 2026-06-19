import SwiftUI

/// Direction in which the shimmer gradient travels.
public enum ShimmerDirection: Equatable, Sendable {
    case leftToRight
    case rightToLeft
    case topToBottom

    var startPoint: UnitPoint {
        switch self {
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        case .topToBottom: return .top
        }
    }

    var endPoint: UnitPoint {
        switch self {
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        case .topToBottom: return .bottom
        }
    }

    var isVertical: Bool {
        self == .topToBottom
    }
}

/// Controls shimmer animation timing and motion behavior.
public struct AnimationConfig: Equatable, Sendable {
    public var speed: Double
    public var direction: ShimmerDirection
    public var respectsReduceMotion: Bool

    public init(
        speed: Double = 1.5,
        direction: ShimmerDirection = .leftToRight,
        respectsReduceMotion: Bool = true
    ) {
        self.speed = speed
        self.direction = direction
        self.respectsReduceMotion = respectsReduceMotion
    }

    public var duration: Double {
        max(0.5, 2.0 / speed)
    }

    public static let `default` = AnimationConfig()
}
