//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation

final class TestExpectation: @unchecked Sendable {
    // MARK: Properties

    private let condition = NSCondition()
    private var isFulfilled = false

    // MARK: Internal

    func fulfill() {
        condition.lock()
        isFulfilled = true
        condition.signal()
        condition.unlock()
    }

    func wait(timeout: TimeInterval) -> Bool {
        condition.lock()
        let expirationDate = Date().addingTimeInterval(timeout)
        while !isFulfilled {
            if !condition.wait(until: expirationDate) {
                condition.unlock()
                return false
            }
        }
        condition.unlock()
        return true
    }
}
