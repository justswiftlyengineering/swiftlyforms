//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI
import Combine
import SwiftlyFormsCore

open class SwiftlyFormManager: ObservableObject {
  private var fieldState: [String: SFs.FieldState] = [:]
  private var fieldDefaults: [String: Int] = [:]
  private var fieldIndexes: [String] = []
  private var fieldTypes: [String: SFs.FieldType] = [:]
  private var fieldTypeStateCreator: [SFs.FieldType: SFs.FieldState.Type] = [:]
  
  @Published public var formIsValid: Bool
  @Published public var focusedFieldName: String?
  public var ownState: SFs.FieldState?
  public var validationMode: SFs.FieldValidationMode
  
  public private(set) static var currentActiveForm: SwiftlyFormManager?
  
  var focusCallable: Cancellable?
  
  public init(validByDefault: Bool = true, validationMode: SFs.FieldValidationMode = .onBlur, autoFocusField: String? = nil) {
    _formIsValid = Published(initialValue: validByDefault)
    self._focusedFieldName = Published(initialValue: autoFocusField)
    self.validationMode = validationMode
    focusCallable = $focusedFieldName.sink { value in
      if value == nil {
        SwiftlyFormManager.currentActiveForm = nil
      }
      else {
        SwiftlyFormManager.currentActiveForm = self
      }
    }
  }
  
  public func getFieldNames() -> [String] {
    return Array(fieldState.keys)
  }
  
  @MainActor
  public func updatefocusedfield(fieldName: String?) {
    self.focusedFieldName = fieldName
  }
  
  @MainActor
  public func addField<Content: View>(
    fieldName: String,
    fieldType: SFs.FieldType,
    validationMode: SFs.FieldValidationMode? = nil,
    creator: () -> Content) -> some View {
      return creator()
        .modifier(FieldFocusModifier())
        .environment(\.swiftlyFormFieldType, fieldType)
        .environment(\.swiftlyFormFieldName, fieldName)
        .environmentObject(getFieldState(name: fieldName, type: fieldType))
        
        
  }
  
  @MainActor
  public func addFieldExporting<Content: View>(
    fieldName: String,
    fieldType: SFs.FieldType,
    validationMode: SFs.FieldValidationMode? = nil,
    creator: () -> Content) -> some View {
      return creator()
        .modifier(FieldFocusModifier())
        .environment(\.swiftlyFormFieldType, fieldType)
        .environment(\.swiftlyFormFieldName, fieldName)
        .environmentObject(getFieldState(name: fieldName, type: fieldType))
        .environmentObject(self)
        
        
  }
  
  @MainActor
  public static func addField<Content: View>(manager: SwiftlyFormManager,
                                  fieldName: String,
                                  fieldType: SFs.FieldType,
                                  validationMode: SFs.FieldValidationMode? = nil,
                                  creator: () -> Content) -> some View {
    return manager
      .addFieldExporting(fieldName: fieldName, fieldType: fieldType, validationMode: validationMode, creator: creator)
  }
  
  @MainActor
  public func setDefaultValue<T: Equatable>(fieldName name: String, value: T?, forceOverride: Bool = false) {
    let isSet = fieldDefaults[name] != nil
    if !isSet || forceOverride == true {
      getFieldState(fieldName: name)?.setValue(value: .typed(value: value), isDefault: true)
    }
  }
  
  public func getFieldState(fieldName name: String) -> SFs.FieldState? {
    return fieldState[name]
  }
    
  func getFieldState(name: String, type: SFs.FieldType, validationMode: SFs.FieldValidationMode? = nil) -> SFs.FieldState {
    guard let state = fieldState[name] else {
      let state = createStateForType(type: type, name: name)
      state.validationMode = validationMode ?? self.validationMode
      state.delegate = self
      fieldTypes[name] = type
      fieldState[name] = state
      fieldIndexes.append(name)//[name] = fieldState.count
      return state
    }
    return state
  }
  
  public func dismissKeyboard() {
    Task { @MainActor in
      self.updatefocusedfield(fieldName: nil)
    }
  }
  
  @discardableResult
  @MainActor
  public func validate(showErrorMessage: Bool = true) -> Bool {
    var isValid = true
    for item in fieldState.values {
      if !item.validate(showErrorMessage: showErrorMessage) {
        isValid = false
      }
    }
    self.formIsValid = isValid
    return self.formIsValid
  }
  
  func createStateForType(type: SFs.FieldType, name: String) -> SFs.FieldState {
    guard let registeredType = fieldTypeStateCreator[type] else {
      return SFs.FieldState(fieldName: name, fieldType: type)
    }
    return registeredType.init(fieldName: name, fieldType: type)
  }
  
  public func getFieldValue(fieldName: String) -> Any? {
    return getFieldState(fieldName: fieldName)?.value?.value
  }
  
  public func getFieldValueAsString(fieldName: String)-> String? {
    return getFieldState(fieldName: fieldName)?.forceValueType()
  }
  
  public func getFieldValueAsType<T>(fieldName: String)-> T? {
    return getFieldState(fieldName: fieldName)?.getValue()
  }
  
  public func getFieldValueAsBool(fieldName: String, defaultValue: Bool = false)-> Bool {
    return getFieldState(fieldName: fieldName)?.forceValueType() ?? defaultValue
  }
  
  public func getFieldValues() -> [String: Any] {
    var values: [String: Any] = [:]
    fieldState.keys.forEach { values[$0] = fieldState[$0]?.value?.value }
    return values
  }
  
  public subscript<T>(key: String)-> T? {
      return getFieldValueAsType(fieldName: key)
  }
}

extension SwiftlyFormManager: FieldStateChangeDelegate {
  public func onStateChanged(state: SFs.FieldState) {
    Task { @MainActor in
      for item in fieldState.values {
        if !item.isValid {
          self.formIsValid = false
          return
        }
      }
      self.formIsValid = true
    }
  }
  
  
}
