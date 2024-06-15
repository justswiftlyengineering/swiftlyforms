//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI



public extension SwiftlyFieldValidatorType {
  /// Provides a maxLength validator that ensures a value does not exceed the specified max length
  static let maxLength = SwiftlyFieldValidatorType(type: String(describing: CountLimitValidator.self) + "maxLength") {
    CountLimitValidator()
  }
  
  /// Provides a minLength validator that ensures a value is greater than the specified length
  static let minLength = SwiftlyFieldValidatorType(type: String(describing: CountLimitValidator.self) + "minLength") {
    CountLimitValidator()
  }
  
  /// Provides a minLength validator that ensures a value is has exactly the same length as the specified length
  static let exactLength = SwiftlyFieldValidatorType(type: String(describing: CountLimitValidator.self) + "exactLength") {
    CountLimitValidator()
  }
}

/// A validator that matches against the length of the value it's validating against
/// - Note: By default, values are considered valid if they are nil. Can be overridden by setting the ``CountLimitValidator.Config.nullablesAreValid``
public class CountLimitValidator: SwiftlyFieldValidator {
  
  public enum LimitType {
    case maxLength(length: Int, message: String?)
    case minLength(length: Int, message: String?)
    case exactLength(length: Int, message: String?)
    
    func getMessage(defaultMessage: String?) -> String {
      if let message = defaultMessage {
        return message
      }
      switch self {
      case let .maxLength(length, message):
        return message ?? "Maximum length of \(length) exceeded"
      
      case let .minLength(length, message):
        return message ?? "Min length required is \(length)"
      
      case let .exactLength(length, message):
        return message ?? "Length must be exactly \(length)"
      }
    }
    
    func isValid(string: String) -> Bool {
      isValid(count: string.count)
    }
    
    func isValid(count: Int) -> Bool {
      switch self {
      case let .maxLength(length, _):
        return count <= length
      case let .minLength(length, _):
        return count >= length
      case let .exactLength(length, _):
        return count == length
      }
    }
    
    func getType() -> SwiftlyFieldValidatorType {
      switch self {
      case .maxLength:
        return .maxLength
      case .minLength:
        return .minLength
      case .exactLength:
        return .exactLength
      }
    }
  }
  
  public struct Config {
    var limitType: LimitType
    var invalidMessage: String?
    var nullablesAreValid: Bool
    
    public init(limitType: LimitType, invalidMessage: String?, nullablesAreValid: Bool = true) {
      self.limitType = limitType
      self.invalidMessage = invalidMessage
      self.nullablesAreValid = nullablesAreValid
    }
  }
  
  
  public func isValid(value: Any?, config: Any?) -> String? {
    guard let config = config as? Config else {
      fatalError("A CharacterLimitValidator.Config configuration is required")
    }
    return isValid(value: value, config: config)
  }
  
  func isValid(value: Any?, config: Config) -> String? {
    guard let value = value else {
      // if no value is set and the validation type is minLength, then it's a failed validation
      if config.nullablesAreValid {
        return nil
      }
      return generateErrorMessage(config: config)
    }
    return validateValue(value: value, config: config)
  }
  
  func validateValue(value: Any, config: Config) -> String? {
    if let value = value as? String, config.limitType.isValid(string: value) {
      return nil
    }
    else if let val = value as? (any Collection), config.limitType.isValid(count: val.count) {
      return nil
    }
    return generateErrorMessage(config: config)
  }
  
  func generateErrorMessage(config: Config) -> String {
    return config.limitType.getMessage(defaultMessage: config.invalidMessage)
  }
  
  
}

public extension View {
  func swiftlyformValidator_characterLength(_ type: CountLimitValidator.LimitType, message: String? = nil) -> some View {
    self.swiftlyformValidator_characterLength(CountLimitValidator.Config(limitType: type, invalidMessage: message))
  }
  
  func swiftlyformValidator_characterLength(_ config: CountLimitValidator.Config) -> some View {
    self.swiftlyform_addValidator(validator: config.limitType.getType(), config: config)
  }
}
