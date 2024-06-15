//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

/// A ViewModifier that adds a validator to a View
public struct SwiftlyValidators: ViewModifier {
  
  let validator: SwiftlyFieldValidatorType
  let config: Any?
  @EnvironmentObject var fieldState: SFs.FieldState
  @State private var trigger: Bool = false
  
  /// Create this modifier that registers a Validator with this a field
  init(validator: SwiftlyFieldValidatorType, config: Any?) {
    self.validator = validator
    self.config = config
  }
  
  public func body(content: Content) -> some View {
    fieldState.registerValidator(validator: validator, config: config)
    return content.onChange(of: trigger) { _ in }
  }
  
}

public extension View {
  func swiftlyform_addValidator(validator: SwiftlyFieldValidatorType, config: Any? = nil) -> some View {
    self.modifier(SwiftlyValidators(validator: validator, config: config))
  }
}
