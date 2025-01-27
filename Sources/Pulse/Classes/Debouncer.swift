//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation

/// A class that implements a debouncing mechanism, ensuring that a given action is executed
/// only after a specified delay since the last invocation.
/// The class is generic over `T`, the type of value being debounced.
///
/// This class is marked as `Sendable` to ensure thread-safe usage in concurrent contexts.
public final class Debouncer<T>: Sendable {
    // MARK: Properties

    /// The closure to be executed with the debounced value.
    private let output: @Sendable (T) async -> Void

    /// A thread-safe storage for the state machine that manages debouncing logic.
    private let stateMachine: SafeStorage<StateMachine<T>>

    /// A thread-safe storage for the active task handling the debouncing.
    private let task: SafeStorage<Task<Void, Never>?>

    // MARK: Initialization

    /// Initializes the debouncer with a debouncing duration and an output closure.
    ///
    /// - Parameters:
    ///   - duration: The duration to wait before executing the action.
    ///   - output: The closure to be executed with the debounced value.
    public init(
        duration: ContinuousClock.Duration,
        output: @Sendable @escaping (T) async -> Void
    ) {
        stateMachine = SafeStorage(value: StateMachine(duration: duration))
        task = SafeStorage(value: nil)
        self.output = output
    }

    // MARK: Deinitialization

    deinit {
        self.task.get()?.cancel()
    }

    // MARK: Public

    /// Emits a new value to the debouncer. If the debouncer is idle, it starts a new task to handle the value.
    /// If a task is already running, it updates the value and resets the waiting time.
    ///
    /// - Parameter value: The new value to debounce.
    public func emit(value: T) {
        let (shouldStartATask, dueTime) = stateMachine.apply { machine in
            machine.newValue(value)
        }

        if shouldStartATask {
            task.set(value: Task { [output, stateMachine] in
                var localDueTime = dueTime
                loop: while true {
                    try? await Task.sleep(until: localDueTime, clock: .continuous)

                    let action = stateMachine.apply { machine in
                        machine.action()
                    }

                    switch action {
                    case let .finishDebouncing(value):
                        await output(value)
                        break loop
                    case let .continueDebouncing(newDueTime):
                        localDueTime = newDueTime
                        continue loop
                    }
                }
            })
        }
    }
}
