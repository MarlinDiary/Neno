//
//  TextViewWrapper.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(parent: TextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.allowsEditingTextAttributes = false // 启用文本属性编辑
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
}
