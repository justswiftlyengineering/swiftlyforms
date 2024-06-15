//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation

extension String {
  func trimmed() -> String? {
    if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return nil
    }
    return self
  }
}
