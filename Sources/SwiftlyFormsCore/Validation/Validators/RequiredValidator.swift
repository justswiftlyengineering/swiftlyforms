//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

public extension SwiftlyFieldValidatorType {
  /// A required validator that ensures the value it is validating against is not nil or empty
  static let required = SwiftlyFieldValidatorType(type: String(describing: RequiredValidator.self)) {
    RequiredValidator()
  }
}

/// A validator that validates if a value is set. A value is valid if
/// - It is not nil
/// - Is a string and is not empty
/// - is a collection and is not empty
public struct RequiredValidator: SwiftlyFieldValidator {
  
  public struct Config {
    var invalidMessage: String?
    public init(message: String? = nil) {
      self.invalidMessage = message
    }
  }
  
  public func isValid(value: Any?, config: Any?) -> String? {
    precondition(config is RequiredValidator.Config, "config must be an instance of RequiredValidator.Config")
    guard let val = value else {
      return generateErrorMessage(config: config)
    }
    guard let _ = (val as? String)?.trimmed() else {
      return generateErrorMessage(config: config)
    }
    if let sequence = val as? (any Collection), sequence.isEmpty {
      return generateErrorMessage(config: config)
    }
    return nil
  }
  
  func generateErrorMessage(config: Any?) -> String {
    (config as? Config)?.invalidMessage ?? "This field is required"
  }

}

public extension View {
  /// Adds a required validator to a Field using the provided ``RequiredValidator.Config`` config
  func swiftlyformValidator_required(_ config: RequiredValidator.Config? = nil) -> some View {
    self.swiftlyform_addValidator(validator: .required, config: config ?? RequiredValidator.Config.init())
  }
}
