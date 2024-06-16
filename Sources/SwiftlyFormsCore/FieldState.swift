//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

extension SFs {
  
  /// A FieldState holds information about the current state of a SwiftlyForm field. It's an `ObservableObject` that publishes changes to some of its properties
  open class FieldState: ObservableObject {
    
    /// The name of the field
    public var fieldName: String
    
    /// The type of field
    public var fieldType: FieldType
    
    /// The current value of the field
    /// - Attention: A published field
    @Published public var value: EquatableValue?
    
    /// states if the field is currently valid
    /// - Attention: A published field
    @Published public var isValid = true
    
    /// States if the field is currently dirty. i.e if it's value has changed from it's initial one
    /// - Attention: A published field
    @Published public var isDirty = false
    
    /// Provides the error message for the field
    /// - Attention: A published field
    @Published public private(set) var errorMessage: String?
    
    /// States the validation mode that will be used to validate this field
    /// - Attention: A published field
    @Published public var validationMode: FieldValidationMode = .change
    
    var validators: [ValidatorKey: ValidatorInstance] = [:]
    public var delegate: FieldStateChangeDelegate?
    
    required public init(fieldName: String, fieldType: FieldType) {
      self.fieldName = fieldName
      self.fieldType = fieldType
    }
    
    /// registers the specified `SwiftlyFieldValidatorType` validator for this field using the specified `config`
    public func registerValidator(validator: SwiftlyFieldValidatorType, config: Any? = nil) {
      self.validators[ValidatorKey(key: validator, order: validators.count)] = ValidatorInstance(config: config)
    }
    
    /// Set's the value for this field. The field is immediately validated if `isDefault` is false or if the fields `validationMode` is ``FieldValidationMode.change``
    @MainActor
    public func setValue(value: EquatableValue?, isDefault: Bool = false) {
      self.value = value
      if isDefault {
        return
      }
      
      self.isDirty = true
      if validationMode == .change {
        self.validate()
      }
    }
    
    /// Returns the wrapped field value
    public func getValue<T>() -> T? {
      return value?.value as? T
    }
    
    public func forceValueType<T: Equatable>()-> T? {
      guard let typed = value as? TypedValue<T?>, let value = typed.rawValue else {
        return getValue()
      }
      return value
    }
    
    @MainActor
    public func onFocusValueChanged(isFocused: Bool) {
      if self.validationMode.rawValue >= FieldValidationMode.manual.rawValue {
        return
      }
      if !isDirty {
        return
      }
      if self.validationMode.rawValue <= FieldValidationMode.onBlur.rawValue {
        self.validate()
      }
    }
    
    /// Validates this field, stating whether or not the error message should be set if validation fails
    /// The field's registered delegate is notified about the state change after validation has completed
    @MainActor
    @discardableResult
    public func validate(showErrorMessage: Bool = true) -> Bool {
      var errorMessage: String? = nil
      for key in validators.keys.sorted() {
        if let message = key.key.create().isValid(value: self.value?.value, config: validators[key]?.config) {
          errorMessage = message
          break
        }
      }
      if showErrorMessage {
        self.errorMessage = errorMessage
      }
      else {
        self.errorMessage = nil
      }
      self.isValid = errorMessage == nil
      delegate?.onStateChanged(state: self)
      return isValid
    }
  }
}

public protocol FieldStateChangeDelegate {
  func onStateChanged(state: SFs.FieldState)
}

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}


extension View {
    func clearScrollContentBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}
