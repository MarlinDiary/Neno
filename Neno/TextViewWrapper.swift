//
//  TextViewWrapper.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI
import UIKit

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        var lastCharacterWasNewline = false

        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // 检查是否输入了换行符
            if text == "\n" {
                // 获取当前段落
                let currentText = textView.text as NSString
                let currentParagraphRange = currentText.paragraphRange(for: range)
                let currentParagraph = currentText.substring(with: currentParagraphRange)

                // 检查当前段落是否为空（仅包含数字 + . 或 - ）
                let trimmedParagraph = currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedParagraph == "-" || trimmedParagraph.range(of: #"^\d+\.\s*$"#, options: .regularExpression) != nil {
                    // 删除段落开头的数字 + . 或 - ，并阻止换行
                    let updatedParagraph = currentParagraph
                        .replacingOccurrences(of: #"^\d+\.\s*"#, with: "", options: .regularExpression)
                        .replacingOccurrences(of: "^-\\s*", with: "", options: .regularExpression)
                    textView.textStorage.replaceCharacters(in: currentParagraphRange, with: updatedParagraph)
                    textView.selectedRange = NSRange(location: currentParagraphRange.location, length: 0)
                    return false
                }

                if lastCharacterWasNewline {
                    lastCharacterWasNewline = false
                    return true // 允许插入第二个换行符以取消符号
                }
                lastCharacterWasNewline = true

                // 检查上一行是否以"- "开头，如果是，则在下一行添加"- "
                if currentParagraph.starts(with: "- ") {
                    textView.insertText("\n- ")
                    return false
                }

                // 检查当前段落是否以"数字 + . "开头
                let numberPattern = #"^\d+\. "#
                if let _ = currentParagraph.range(of: numberPattern, options: .regularExpression) {
                    let numberPattern = #"(\d+)\. "#
                    if let regex = try? NSRegularExpression(pattern: numberPattern) {
                        let matches = regex.matches(in: currentParagraph, range: NSRange(location: 0, length: currentParagraph.utf16.count))
                        if let match = matches.first, let numberRange = Range(match.range(at: 1), in: currentParagraph) {
                            let number = Int(currentParagraph[numberRange]) ?? 0
                            textView.insertText("\n\(number + 1). ")
                            return false
                        }
                    }
                }
            } else {
                lastCharacterWasNewline = false
            }

            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.allowsEditingTextAttributes = true // 启用文本属性编辑
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.showsVerticalScrollIndicator = false
        //textView.font = UIFont(name: "Fusion Pixel 12px Monospaced zh_hans Regular", size: 20)
        textView.backgroundColor = .clear
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
