//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

extension String {
  func isValidEmail(emailRegex: String) -> Bool {
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
  }
}

public extension SwiftlyFieldValidatorType {
  /// Registers an email validator generator
  static let email = SwiftlyFieldValidatorType(type: String(describing: EmailValidator.self)) {
    EmailValidator()
  }
}

/// An email validator verifies if a string is a valid email using the regular expression "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
/// - Note: This field threats its valid as valid if
///   - The value to test against is nil
///   - The value is a string, but is an empty string. You can override this behavor by setting EmailValidator.Config.emptyStringIsValid to false
///   - The value is a string and is a valid email
public class EmailValidator: SwiftlyFieldValidator {
  
  /// The configuration that can be used to configure the validator instance when performing validations
  public struct Config {
    
    var invalidMessage: String?
    var emailRegEx: String?
    var emptyStringIsValid: Bool
    /// The default regular expression used to test the validity of an email
    public static let defaultRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    /// Creates a config that will used the specified `invalidMessage` if invalid and uses the specified `emailRegEx` to validate the email address
    /// - Note: The default regular expression used is ``EmailValidator.Config.defaultRegEx``
    /// - Parameters:
    ///  - emptyStringIsValid: Set to true if empty strings should be treated as valid inputs (Defaults to True)
    ///  - invalidMessage: The error message to return if value is invalid
    ///  - emailRegEx: Regular expression to use when testing for email validity
    public init(emptyStringIsValid: Bool = true, invalidMessage: String?, emailRegEx: String? = nil) {
      self.invalidMessage = invalidMessage
      self.emailRegEx = emailRegEx
      self.emptyStringIsValid = emptyStringIsValid
    }
  }
  
  public func isValid(value: Any?, config: Any?) -> String? {
    guard let config = config as? EmailValidator.Config else {
      fatalError("config must be an instance of EmailValidator.Config")
    }
    guard let val = value as? String else {
      // if it's empty we don't do any validation
      return nil
    }
    if val.isEmpty && config.emptyStringIsValid {
      return nil
    }
    if val.isValidEmail(emailRegex: config.emailRegEx ?? Config.defaultRegEx) {
      return nil
    }
    return generateErrorMessage(config: config)
  }
  
  func generateErrorMessage(config: Config) -> String {
    config.invalidMessage ?? "Please provide a valid email"
  }
  
  
}

public extension View {
  /// Adds an email validator modifier to the field
  func swiftlyformValidator_validEmail(_ config: EmailValidator.Config? = nil) -> some View {
    self.swiftlyform_addValidator(validator: .email, config: config)
  }
}
