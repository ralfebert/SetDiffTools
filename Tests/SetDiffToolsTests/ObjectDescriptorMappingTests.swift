// Copyright © 2020 Ralf Ebert
// Licensed under MIT license.

import SetDiffTools
import XCTest

struct GhostDescription: Identifiable {
    var id = UUID()
    var name: String
}

class Ghost {
    var name: String

    init(name: String) {
        self.name = name
    }
}

@available(iOS 13.0, macOS 10.15, *)
class ObjectDescriptorMappingTests: XCTestCase {

    func testObjectDescriptorMapping() {
        var ghosts = [Ghost]()

        var ghostMapping = ObjectDescriptorMapping<UUID, GhostDescription, Ghost>(
            handleAdd: { descriptor in
                let p = Ghost(name: descriptor.name)
                ghosts.append(p)
                return p
            },
            handleRemove: { ghost in
                ghosts.removeAll { $0 === ghost }
            },
            handleUpdate: { descriptor, ghost in
                ghost.name = descriptor.name + "!"
            }
        )

        var casperDescription = GhostDescription(name: "Casper")
        ghostMapping.update([casperDescription])
        XCTAssertEqual(["Casper!"], ghosts.map { $0.name })
        let casper = ghosts[0]

        // update
        casperDescription.name = "Casper Cool"
        ghostMapping.update([casperDescription])
        XCTAssertEqual(["Casper Cool!"], ghosts.map { $0.name })
        XCTAssertTrue(casper === ghosts[0])

        // add & remove
        ghostMapping.update([GhostDescription(name: "Slimer")])
        XCTAssertEqual(["Slimer!"], ghosts.map { $0.name })
        XCTAssertTrue(casper !== ghosts[0])

    }

}
