//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation

extension SFs {
  /// Defines the various validation mode a field can have. A validation mode defines the point in time a field will run it's values through it's set of validators
  public enum FieldValidationMode: Int {
    
    /// Validation happens only when it is manually requested for
    case manual = 100
    
    /// Validation will happen each time focus leaves the field
    case onBlur = 1
    
    /// Validation will happen when the value of a field changes. For example, in a text field, with this mode validation would happen each time a new character is typeed to deleted
    case change = 0
  }
  
  struct ValidatorInstance {
    var config: Any?
  }
  
  struct ValidatorKey: Hashable, Comparable {
    
    var key: SwiftlyFieldValidatorType
    var order: Int
    
    static func < (lhs: ValidatorKey, rhs: ValidatorKey) -> Bool {
      lhs.order < rhs.order
    }
    
  }
}

/// A validator type is used to associate a type of validation with its validator
/// Basically an instance of SwiftlyFieldValidatorType is a validator generator, that generates a validator when needed
public struct SwiftlyFieldValidatorType: Hashable, CustomStringConvertible {
  
  public var description: String {
    return "\(type)"
  }
  
  /// The type of validator
  public var type: String
  
  var validatorCreator: () -> SwiftlyFieldValidator
  
  /// Creates a `SwiftlyFieldValidatorType` with a type, and a creator. Validators are immutable and will always be created each time they are to run validations
  public init(type: String, validatorCreator: @escaping () -> SwiftlyFieldValidator) {
    self.type = type
    self.validatorCreator = validatorCreator
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(type)
  }
  
  public func create() -> SwiftlyFieldValidator {
    return validatorCreator()
  }
  
  public static func == (lhs: SwiftlyFieldValidatorType, rhs: SwiftlyFieldValidatorType) -> Bool {
    lhs.type == rhs.type
  }
}

/// A Field validator is a component that can validate a field's value, using a provided configuration data.
public protocol SwiftlyFieldValidator {
  /// Checks if the ``value`` is valid for this validator using data provided in `config`
  /// - Returns: Return nil if value is valid, else return the error message
  func isValid(value: Any?, config: Any?) -> String?
}
