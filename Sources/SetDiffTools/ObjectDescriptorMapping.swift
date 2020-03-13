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

        // remove objects that are not represented in descriptors anymore
        for id in Set(objects.keys).subtracting(Set(descriptors.map { $0.id as! Identifier })) {
            handleRemove(objects.removeValue(forKey: id)!)
        }

        // add+update newly added objects
        // update existing objects
        for descriptor in descriptors {
            var object = objects[descriptor.id as! Identifier]
            if object == nil {
                object = handleAdd(descriptor)
                objects[descriptor.id as! Identifier] = object
            }
            handleUpdate(descriptor, object!)
        }

        self.objects = objects
    }

}
