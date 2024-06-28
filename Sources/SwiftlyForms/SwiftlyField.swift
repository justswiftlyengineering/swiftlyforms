

import Foundation


import SwiftUI
import SwiftlyFormsCore

public struct SwiftlyFieldConfiguration {
  var fieldState: SFs.FieldState
}

public protocol SwiftlyField: View {
  associatedtype Field : View
  associatedtype Value: Equatable
  
  var formManager: SwiftlyFormManager { get }
  
  var fieldName: String { get }
  
  var supportedFieldType: SFs.FieldType { get }
  var supportedStateType: SFs.FieldStateType { get }
  var fieldInternalValue: Value { get }
  
  
  @ViewBuilder
  func makeInteractiveBody(configuration: SwiftlyFieldConfiguration) -> Self.Field
  func addDefaultChangeHandlers() -> Bool
  func usesFocusableField() -> Bool
  func setInternalFieldValue(value: Value?)
  
  @MainActor
  func setFieldStateValue(value: Value?)
  @MainActor
  func onInternalFieldValueChanged(value: Value)
  @MainActor
  func onFieldStateValueChanged(value: EquatableValue?)
  @MainActor
  func onFieldAppeared()
  @MainActor
  func onGainedFocus()
  @MainActor
  func onLostFocus()
  
}

extension SwiftlyField {
  
  public var supportedStateType: SFs.FieldStateType { .generic }
  
  public func buildField<Content: View>(builder: @escaping () -> Content) -> some View {
    validateFieldType {
      builder()
    }
    .preference(key: SwiftlyFormFieldUsesFocusableField.self, value: usesFocusableField())
  }
  
  public func usesFocusableField() -> Bool { true }
  
  public func addDefaultChangeHandlers() -> Bool { true }
  
  public func getFieldState() -> SFs.FieldState? {
    formManager.getFieldState(fieldName: fieldName)
  }
  
  public func setInternalFieldValue(value: Value?) {
    
  }
    
  @MainActor
  public func onInternalFieldValueChanged(value: Value) {
    getFieldState()?.setValue(value: .typed(value: value))
  }
  
  @MainActor
  public func onFieldStateValueChanged(value: EquatableValue?) {
    if let value = value?.value as? Value {
      self.setInternalFieldValue(value: value)
    }
    else {
      self.setInternalFieldValue(value: nil)
    }
  }
  
  @MainActor
  public func onFieldAppeared() {
    guard let val: Value = getFieldState()?.forceValueType() else {
      return
    }
    self.setInternalFieldValue(value: val)
  }
  
  @MainActor
  public func setFieldStateValue(value: Value?) {
    formManager.setValue(fieldName: fieldName, value: value)
  }
  
  @MainActor
  public func onGainedFocus() {}
  
  @MainActor
  public func onLostFocus() {}
  
}


public extension SwiftlyField {
  @MainActor
  var body: some View {
    wrapWithDefaultHandler {
      buildField {
        makeInteractiveBody(configuration: SwiftlyFieldConfiguration(fieldState: getFieldState()!))
      }
    }
  }
  
  @MainActor
  func wrapWithDefaultHandler<T: View>(view: () -> T) -> some View {
    Group {
      if addDefaultChangeHandlers() {
        view()
          .onChange(of: fieldInternalValue) { new in
            onInternalFieldValueChanged(value: new)
          }
          .onEnvironmentChange(keyPath: \.swiftlyFormCurrentValue, perform: { value in
            self.onFieldStateValueChanged(value: value)
          })
          .onEnvironmentChange(keyPath: \.swiftlyFormHasFocus, perform: { value in
            if value {
              self.onGainedFocus()
            }
            else {
              self.onLostFocus()
            }
          })
          .onAppear {
            onFieldAppeared()
          }
      }
      else {
        view()
      }
    }
  }
  
  func validateFieldType<Content: View>(builder: @escaping () -> Content) -> some View {
//    if supportedStateType.firstIndex(of: fieldType) == nil {
//      fatalError("Field type '\(self.fieldType.typeName)' is not supported by \(type(of: self))")
//    }
    let name = "\(type(of: self))"
    return ValidatableSwfitlyField(actualSupportedType: self.supportedFieldType, actualSupportedStateType: self.supportedStateType, typeName: name) {
      builder()
    }
//    return builder()
  }
}

struct ValidatableSwfitlyField<Content: View>: View {
  var actualSupportedType: SFs.FieldType
  var actualSupportedStateType: SFs.FieldStateType
  var fieldTypeName: String
  var builder: () -> Content
  
  @Environment(\.swiftlyFormFieldType) var userSpecifiedType: SFs.FieldType
  @Environment(\.swiftlyFormFieldStateType) var userSpecifiedFieldStateType: SFs.FieldStateType
  
  init(actualSupportedType: SFs.FieldType, actualSupportedStateType: SFs.FieldStateType, typeName: String, builder: @escaping () -> Content) {
    self.actualSupportedType = actualSupportedType
    self.actualSupportedStateType = actualSupportedStateType
    self.builder = builder
    self.fieldTypeName = typeName
  }
  
  var body: some View {
    builder()
      .onAppear {
        if actualSupportedType != userSpecifiedType {
          fatalError("Field type '\(self.userSpecifiedType.typeName)' is not supported by \(fieldTypeName)")
        }
        else if actualSupportedStateType != userSpecifiedFieldStateType {
          fatalError("Field State type '\(self.userSpecifiedFieldStateType.typeName)' is not supported by \(fieldTypeName)")
        }
      }
  }
}
