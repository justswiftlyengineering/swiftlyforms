//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

private struct SwiftlyFormFieldName: EnvironmentKey {
    // 1
  static let defaultValue: String = ""
}

private struct SwiftlyFormFieldType: EnvironmentKey {
    // 1
  static let defaultValue: SFs.FieldType = .generic
}

private struct SwiftlyFormHasFocus: EnvironmentKey {
    // 1
  static let defaultValue: Bool = false
}

private struct SwiftlyFormFieldIsValid: EnvironmentKey {
    // 1
  static let defaultValue: Bool = true
}

private struct SwiftlyFormFieldIsDirty: EnvironmentKey {
    // 1
  static let defaultValue: Bool = false
}

private struct SwiftlyFormFieldErrorMessage: EnvironmentKey {
    // 1
  static let defaultValue: String? = nil
}

private struct SwiftlyFormFieldCurrentValue: EnvironmentKey {
    // 1
  static let defaultValue: Any? = nil
}

public extension EnvironmentValues {
  var swiftlyFormFieldName: String {
    get { self[SwiftlyFormFieldName.self] }
    set { self[SwiftlyFormFieldName.self] = newValue }
  }
  
  var swiftlyFormFieldType: SFs.FieldType {
    get { self[SwiftlyFormFieldType.self] }
    set { self[SwiftlyFormFieldType.self] = newValue }
  }
  
  var swiftlyFormHasFocus: Bool {
    get { self[SwiftlyFormHasFocus.self] }
    set { self[SwiftlyFormHasFocus.self] = newValue }
  }
  
  var swiftlyFormFieldIsValid: Bool {
    get { self[SwiftlyFormFieldIsValid.self] }
    set { self[SwiftlyFormFieldIsValid.self] = newValue }
  }
  
  var swiftlyFormFieldIsDirty: Bool {
    get { self[SwiftlyFormFieldIsDirty.self] }
    set { self[SwiftlyFormFieldIsDirty.self] = newValue }
  }
  
  var swiftlyFormFieldErrorMessage: String? {
    get { self[SwiftlyFormFieldErrorMessage.self] }
    set { self[SwiftlyFormFieldErrorMessage.self] = newValue }
  }
  
  var swiftlyFormCurrentValue: Any? {
    get { self[SwiftlyFormFieldCurrentValue.self] }
    set { self[SwiftlyFormFieldCurrentValue.self] = newValue }
  }
}
