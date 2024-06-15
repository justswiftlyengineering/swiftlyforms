//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation


import SwiftUI
import SwiftlyFormsCore

public protocol SwiftlyField: View {
  associatedtype Field : View
  
  var formManager: SwiftlyFormManager { get }
  var fieldType: SFs.FieldType { get }
  var supportedTypes: [SFs.FieldType] { get }
  
  @MainActor
  var interactiveField: Self.Field { get }
  
  func usesFocusableField() -> Bool
  
}

extension SwiftlyField {
  func buildField<Content: View>(builder: () -> Content) -> some View {
    validateFieldType {
      builder()
    }
    .preference(key: SwiftlyFormFieldUsesFocusableField.self, value: usesFocusableField())
  }
  
  public func usesFocusableField() -> Bool { true }
}


public extension SwiftlyField {
  @MainActor
  var body: some View {
    buildField{
      self.interactiveField
    }
  }
  
  func validateFieldType<Content: View>(builder: () -> Content) -> some View {
    if supportedTypes.firstIndex(of: fieldType) == nil {
      fatalError("Field type '\(self.fieldType.typeName)' is not supported by \(type(of: self))")
    }
    return builder()
  }
}
