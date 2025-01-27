//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation
@testable import Pulse
import Testing

final class DebouncerTests {
    @Test
    func test_debouncerSkipsIntermediateValues() async {
        let storage = Storage<Int>(value: .zero)
        let expectation = TestExpectation()
        let debouncer = Debouncer<Int>(duration: .milliseconds(200)) { value in
            await storage.update(value)
            expectation.fulfill()
        }

        for index in 0 ... 4 {
            DispatchQueue.global().asyncAfter(
                deadline: .now().advanced(by: .milliseconds(100 * index))
            ) {
                debouncer.emit(value: index)
            }
        }

        #expect(expectation.wait(timeout: 5.0))
        #expect(await storage.value == 4)
    }
}
