//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

actor Storage<Value> {
    // MARK: Properties

    var value: Value

    // MARK: Initialization

    init(value: Value) {
        self.value = value
    }

    // MARK: Internal

    func update(_ value: Value) {
        self.value = value
    }
}
