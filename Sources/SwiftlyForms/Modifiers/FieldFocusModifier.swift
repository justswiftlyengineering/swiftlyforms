//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftlyFormsCore
import SwiftUI

struct FieldFocusModifier: ViewModifier {
  
  @Environment(\.swiftlyFormFieldName) public var fieldName: String
  
  
  @EnvironmentObject var fieldState: SFs.FieldState
  @EnvironmentObject public var formManager: SwiftlyFormManager
  
  @FocusState private var focusedField: String?
  @State private var isEnvironmentObjectSet = false
  
  @State public var allowChange = true
  @State var hasFocus = false
  @State var errorMessage: String?
  @State var isValid: Bool = true
  @State var isDirty: Bool = false
  @State var currentValue: Any?
  @State var usesFocusableField: Bool = true
  
  var focusIsActive: Bool {
    if usesFocusableField {
      return focusedField == fieldName
    }
    else {
      return formManager.focusedFieldName == fieldName
    }
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear{
        if !isEnvironmentObjectSet {
          isEnvironmentObjectSet = true
          self.onFirstTimeStateReceived()
          self.onFocusStateChanged()
        }
      }
      .onChange(of: formManager.focusedFieldName) { newValue in
        if allowChange {
          self.focusedField = formManager.focusedFieldName
          self.onFocusStateChanged()
        }
      }
      .onChange(of: focusedField) { val in
        self.fieldFocusChanged(newFieldName: val)
      }
      .onChange(of: fieldState.errorMessage) { new in
        self.errorMessage = new
        
      }
      .onChange(of: fieldState.isValid) { new in
        self.isValid = new
      }
      .onChange(of: fieldState.isDirty) { new in
        self.isDirty = new
      }
      .onChange(of: fieldState.value) { new in
        self.currentValue = new?.value
      }
      .onPreferenceChange(SwiftlyFormFieldUsesFocusableField.self) { value in
        self.usesFocusableField = value
      }
      .focused($focusedField, equals: fieldName)
      .environment(\.swiftlyFormHasFocus, hasFocus)
      .environment(\.swiftlyFormFieldErrorMessage, errorMessage)
      .environment(\.swiftlyFormFieldIsValid, isValid)
      .environment(\.swiftlyFormFieldIsDirty, isDirty)
      .environment(\.swiftlyFormCurrentValue, currentValue)
  }
  
  func onFirstTimeStateReceived() {
    self.focusedField = formManager.focusedFieldName
    self.errorMessage = fieldState.errorMessage
    self.isValid = fieldState.isValid
    self.isDirty = fieldState.isDirty
    self.currentValue = fieldState.value?.value
  }
  
  func onFocusStateChanged() {
    self.hasFocus = focusIsActive
    fieldState.onFocusValueChanged(isFocused: focusIsActive)
  }
  
  func fieldFocusChanged(newFieldName: String?) {
    if newFieldName == fieldName {
      self.allowChange = false
      self.formManager.updatefocusedfield(fieldName: fieldName)
      self.allowChange = true
    }
    self.onFocusStateChanged()
  }
}
