//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation

// swiftlint:disable pattern_matching_keywords
struct StateMachine<T> {
    // MARK: Types

    /// Internal states of the state machine.
    private enum State {
        /// Represents the idle state where no debouncing is in progress.
        case idle
        /// Represents the debouncing state with the associated value, due time, and a flag
        /// indicating if a new value was provided while debouncing was still ongoing.
        case debouncing(value: T, dueTime: ContinuousClock.Instant, newValueWhileSleeping: Bool)
    }

    /// Actions that the state machine can perform as a result of processing an event.
    enum Action {
        /// Continue debouncing with the specified due time.
        case continueDebouncing(dueTime: ContinuousClock.Instant)
        /// Finish debouncing and return the final value.
        case finishDebouncing(value: T)
    }

    // MARK: Properties

    /// The current state of the state machine.
    private var state: State
    /// The duration for which debouncing should occur.
    private let duration: ContinuousClock.Duration

    // MARK: Initialization

    /// Initializes the state machine with the specified debouncing duration.
    /// - Parameter duration: The duration for debouncing.
    init(duration: ContinuousClock.Duration) {
        state = .idle
        self.duration = duration
    }

    // MARK: Internal

    /// Handles the arrival of a new value and updates the state accordingly.
    ///
    /// - Parameter value: The new value to process.
    /// - Returns: A tuple containing:
    ///   - A boolean indicating if this is the first value in the current debouncing cycle.
    ///   - The calculated due time for the current debouncing cycle.
    mutating func newValue(_ value: T) -> (Bool, ContinuousClock.Instant) {
        let dueTime = ContinuousClock.now + duration

        switch state {
        case .idle:
            state = .debouncing(value: value, dueTime: dueTime, newValueWhileSleeping: false)
            return (true, dueTime)
        case .debouncing:
            state = .debouncing(value: value, dueTime: dueTime, newValueWhileSleeping: true)
            return (false, dueTime)
        }
    }

    /// Processes the current state and determines the next action to perform.
    ///
    /// - Returns: An `Action` that represents the next step to take.
    /// - Note: Calling this method when the state is inconsistent (e.g., idle) will result in a runtime error.
    mutating func action() -> Action {
        switch state {
        case .idle:
            fatalError("Inconsistent state detected. Defaulting to idle.")
        case .debouncing(let value, _, false):
            state = .idle
            return .finishDebouncing(value: value)
        case .debouncing(let value, let dueTime, true):
            state = .debouncing(value: value, dueTime: dueTime, newValueWhileSleeping: false)
            return .continueDebouncing(dueTime: dueTime)
        }
    }
}

// swiftlint:enable pattern_matching_keywords
