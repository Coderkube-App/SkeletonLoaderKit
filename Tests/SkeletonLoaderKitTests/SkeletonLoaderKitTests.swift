import XCTest
@testable import SkeletonLoaderKit

final class SkeletonLoaderKitTests: XCTestCase {

    func testSkeletonConfigDefaultValues() {
        let config = SkeletonConfig.default
        XCTAssertEqual(config.cornerRadius, 4)
        XCTAssertEqual(config.opacity, 1.0)
        XCTAssertTrue(config.useRedactedStyle)
    }

    func testAnimationConfigDurationScalesWithSpeed() {
        let slow = AnimationConfig(speed: 0.5)
        let fast = AnimationConfig(speed: 3.0)

        XCTAssertGreaterThan(slow.duration, fast.duration)
        XCTAssertEqual(slow.duration, 4.0)
        XCTAssertEqual(fast.duration, 0.5)
    }

    func testShimmerDirectionPoints() {
        XCTAssertEqual(ShimmerDirection.leftToRight.startPoint, .leading)
        XCTAssertEqual(ShimmerDirection.leftToRight.endPoint, .trailing)
        XCTAssertEqual(ShimmerDirection.rightToLeft.startPoint, .trailing)
        XCTAssertEqual(ShimmerDirection.topToBottom.startPoint, .top)
        XCTAssertTrue(ShimmerDirection.topToBottom.isVertical)
        XCTAssertFalse(ShimmerDirection.leftToRight.isVertical)
    }

    func testSkeletonStyleEquality() {
        let a = SkeletonStyle.default
        let b = SkeletonStyle()
        XCTAssertEqual(a, b)
    }

    func testSkeletonPresetEquality() {
        XCTAssertEqual(SkeletonPreset.circle, SkeletonPreset.circle)
        XCTAssertNotEqual(
            SkeletonPreset.roundedRectangle(cornerRadius: 4),
            SkeletonPreset.roundedRectangle(cornerRadius: 8)
        )
    }
}
