//
//  Injected.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

@propertyWrapper
struct Injected<T> {

    private let keyPath: WritableKeyPath<InjectedValues, T>

    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
