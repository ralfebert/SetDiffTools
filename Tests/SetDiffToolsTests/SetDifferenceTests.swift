// Copyright © 2020 Ralf Ebert
// Licensed under MIT license.

import SetDiffTools
import XCTest

struct SetDifferenceElement<T: Equatable & Hashable>: Equatable, Hashable {
    let modification: Modification
    let value: T

    init(_ modification: Modification, _ value: T) {
        self.modification = modification
        self.value = value
    }

    enum Modification {
        case add
        case remove
        case keep
    }
}

/// Returns which elements have to be added to and removed to transform the given 'from' set to the given 'to' set.
func difference<T>(from: Set<T>, to: Set<T>) -> Set<SetDifferenceElement<T>> {
    Set(
        to.subtracting(from).map { .init(.add, $0) } +
            from.subtracting(to).map { .init(.remove, $0) } +
            from.intersection(to).map { .init(.keep, $0) }
    )
}

class SetDifferenceTest: XCTestCase {

    func testEmptySet() {
        XCTAssertEqual(Set<SetDifferenceElement>([]), difference(from: Set<Int>(), to: Set()))
    }

    func testEqual() {
        XCTAssertEqual([SetDifferenceElement(.keep, 1)], difference(from: Set([1]), to: Set([1])))
    }

    func testAdded() {
        XCTAssertEqual([SetDifferenceElement(.add, 1)], difference(from: Set(), to: Set([1])))
    }

    func testRemoved() {
        XCTAssertEqual([SetDifferenceElement(.remove, 1)], difference(from: Set([1]), to: Set([])))
    }

}
