// Copyright © 2020 Ralf Ebert
// Licensed under MIT license.

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
