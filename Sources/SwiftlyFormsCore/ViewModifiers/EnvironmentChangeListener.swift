//
//  File.swift
//  
//
//  Created by Kembene Nkem on 26/06/2024.
//

import Foundation
import SwiftUI

public struct EnvironmentChangeListener<Value>: ViewModifier where Value: Equatable {
  @Environment(\.self) private var environmentValues
  @State private var previousValue: Value
  
  let keyPath: KeyPath<EnvironmentValues, Value>
  let onChange: (Value) -> Void
  
  init(keyPath: KeyPath<EnvironmentValues, Value>, onChange: @escaping (Value) -> Void) {
    self.keyPath = keyPath
    self.onChange = onChange
    self._previousValue = State(wrappedValue: EnvironmentValues()[keyPath: keyPath])
  }
  
  public func body(content: Content) -> some View {
      content
      .onChange(of: environmentValues[keyPath: keyPath]) { newValue in
          if newValue != previousValue {
            previousValue = newValue
            onChange(newValue)
          }
      }
  }
  
}

public extension View {
    func onEnvironmentChange<Value>(
        keyPath: KeyPath<EnvironmentValues, Value>,
        perform action: @escaping (Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(EnvironmentChangeListener(keyPath: keyPath, onChange: action))
    }
}
