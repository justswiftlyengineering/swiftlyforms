//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation
import SwiftUI

struct SwiftlyFormFieldUsesFocusableField: PreferenceKey {
  
  static var defaultValue: Bool = true
  
  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    let newVal = nextValue()
    value =  newVal
  }
}
