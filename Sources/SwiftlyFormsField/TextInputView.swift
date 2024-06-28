//
//  File.swift
//  
//
//  Created by Kembene Nkem on 26/06/2024.
//

import Foundation
import SwiftUI

extension View {
  public func inputView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
    return self.background{
      SetTFKeyboard(keyboardContent: content())
    }
  }
}

fileprivate struct SetTFKeyboard<Content: View>: UIViewRepresentable {
  var keyboardContent: Content
  @State private var hostingController: UIHostingController<Content>?
  
  func makeUIView(context: Context) -> UIView {
    return UIView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.async {
      if let textFieldContainerView = uiView.superview?.superview {
        if let textField = textFieldContainerView.findTextField {
          
          if textField.inputView == nil {
            hostingController = UIHostingController(rootView: keyboardContent)
            hostingController?.view.frame = .init(origin: .zero, size: hostingController?.view.intrinsicContentSize ?? .zero)
            textField.inputView = hostingController?.view
          }
          else {
            hostingController?.rootView = keyboardContent
          }
        }
      }
    }
  }
}

fileprivate extension UIView {
  var allSubviews: [UIView] {
    subviews.flatMap { [$0] + $0.subviews }
  }
  
  var findTextField: UITextField? {
    if let field = allSubviews.first(where: { view in
      view is UITextField
    }) as? UITextField {
      return field
    }
    return nil
  }
}
