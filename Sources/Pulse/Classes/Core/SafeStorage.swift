//
// pulse
// Copyright © 2025 Space Code. All rights reserved.
//

import Foundation

/// A thread-safe storage class that wraps a value of any type `T` and ensures
/// synchronized access using an `os_unfair_lock`.
/// - Note: This class is marked as `@unchecked Sendable` because it performs
///         manual synchronization to ensure thread safety.
final class SafeStorage<T>: @unchecked Sendable {
    // MARK: - Properties

    /// A pointer to an `os_unfair_lock`, used for efficient thread synchronization.
    private let unfairLock: os_unfair_lock_t

    /// The value being safely stored and accessed.
    private var value: T

    // MARK: - Initialization

    /// Initializes the `SafeStorage` instance with the given value.
    ///
    /// - Parameter value: The initial value to store.
    init(value: T) {
        // Allocate memory for the unfair lock and initialize it.
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
        self.value = value
    }

    /// Deinitializes the `SafeStorage` instance, ensuring the lock is properly
    /// deinitialized and deallocated to avoid memory leaks.
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    // MARK: - Internal Methods

    /// Safely retrieves the stored value.
    ///
    /// - Returns: The current value.
    func get() -> T {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        return value
    }

    /// Safely updates the stored value.
    /// - Parameter value: The new value to store.
    func set(value: T) {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        self.value = value
    }

    /// Applies a closure to the stored value, allowing for safe mutation and retrieval.
    ///
    /// - Parameter block: A closure that takes an `inout` reference to the value and returns a result.
    /// - Returns: The result of the closure.
    func apply<R>(block: (inout T) -> R) -> R {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        return block(&value)
    }
}
