//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation

/// A wrapper used to hold field values. It implements the Equatable protocol in order to have it work with SwiftUI .onChange modifiers. By default values created using this class are never equal.
/// You can use the dedicated ``EquatableValue.typed(value:)`` to create equatable instances
/// - SeeAlso: ``TypedValue``
public class EquatableValue: Equatable {
  
  open private(set) var value: Any?
  
  public init(value: Any? = nil) {
    self.value = value
  }
  
  open func isEqual(to: EquatableValue) -> Bool { false }
  
  public static func string(value: String) -> EquatableValue {
    TypedValue(value: value)
  }
  
  public static func typed<T: Equatable>(value: T?) -> EquatableValue {
    TypedValue(value: value)
  }
  
  public static func == (lhs: EquatableValue, rhs: EquatableValue) -> Bool {
    return lhs.isEqual(to: rhs)
  }
  
}

/// An typed implementation of ``EquatableValue`` that allows you to have proper equatability testing
public class TypedValue<T: Equatable>: EquatableValue {
  
  public private(set) var rawValue: T?
  
  public init(value: T? = nil) {
    super.init(value: value)
    rawValue = value
  }
  
  override public func isEqual(to: EquatableValue) -> Bool {
    self.rawValue == (to as? TypedValue)?.rawValue
  }
}
