// Copyright © 2020 Ralf Ebert
// Licensed under MIT license.

import Foundation

/// ObjectDescriptorMapping describes a mapping from identifiable ObjectDescriptors to actual Objects by defining a function to add/remove/update objects from their descriptors.
@available(iOS 13.0, macOS 10.15, *)
public struct ObjectDescriptorMapping<Identifier: Equatable & Hashable, ObjectDescriptor: Identifiable, Object> {

    var objects: [Identifier: Object] = [:]
    var handleAdd: (ObjectDescriptor) -> Object
    var handleRemove: (Object) -> Void
    var handleUpdate: (ObjectDescriptor, Object) -> Void

    public init(handleAdd: @escaping (ObjectDescriptor) -> Object, handleRemove: @escaping (Object) -> Void, handleUpdate: @escaping (ObjectDescriptor, Object) -> Void) {
        self.handleAdd = handleAdd
        self.handleRemove = handleRemove
        self.handleUpdate = handleUpdate
    }

    public mutating func update(_ descriptors: [ObjectDescriptor]) {
        var objects = self.objects
        let descriptorsById = Dictionary(uniqueKeysWithValues: descriptors.map { ($0.id as! Identifier, $0) })

        // add and remove entities as needed
        difference(from: Set(objects.keys), to: Set(descriptorsById.keys)).forEach { e in
            switch e.modification {
            case .add:
                let descriptor = descriptorsById[e.value]!
                objects[descriptor.id as! Identifier] = handleAdd(descriptor)

            case .remove:
                let object = objects.removeValue(forKey: e.value)!
                handleRemove(object)

            case .keep:
                break
            }
        }

        // update attributes of updated and kept entities
        objects.forEach { id, object in
            let descriptor = descriptorsById[id]!
            handleUpdate(descriptor, object)
        }

        self.objects = objects
    }

}
