//
//  TextViewWrapper.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @AppStorage("fontSize") private var fontSize = "Medium"
    @AppStorage("font") private var font = "Arial"

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(parent: TextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            _ = (currentText as NSString).replacingCharacters(in: range, with: text)

            // Handle bullet point and numbered list continuation
            if text == "\n" {
                if let currentRange = textView.selectedTextRange {
                    let currentParagraph = textView.text(in: textView.textRange(from: textView.beginningOfDocument, to: currentRange.start)!) ?? ""
                    let currentLineComponents = currentParagraph.components(separatedBy: .newlines)
                    if let lastLine = currentLineComponents.last {
                        if lastLine.hasPrefix("- ") {
                            if lastLine.count > 2 {
                                // Continue bullet point in new line
                                let updatedText = (currentText as NSString).replacingCharacters(in: range, with: "\n- ")
                                textView.text = updatedText
                                parent.text = updatedText
                                textView.selectedRange = NSRange(location: range.location + 3, length: 0)
                                return false
                            } else {
                                // Remove bullet point if line is empty
                                let updatedText = (currentText as NSString).replacingCharacters(in: NSRange(location: range.location - 2, length: 2), with: "")
                                textView.text = updatedText
                                parent.text = updatedText
                                textView.selectedRange = NSRange(location: range.location - 2, length: 0)
                                return false
                            }
                        } else if let match = lastLine.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                            let numberString = lastLine[match]
                            if lastLine.count > numberString.count {
                                // Continue numbered list in new line
                                if let number = Int(numberString.dropLast(2)) {
                                    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: "\n\(number + 1). ")
                                    textView.text = updatedText
                                    parent.text = updatedText
                                    textView.selectedRange = NSRange(location: range.location + numberString.count + 1, length: 0)
                                    return false
                                }
                            } else {
                                // Remove numbered list if line is empty
                                let updatedText = (currentText as NSString).replacingCharacters(in: NSRange(location: range.location - numberString.count, length: numberString.count), with: "")
                                textView.text = updatedText
                                parent.text = updatedText
                                textView.selectedRange = NSRange(location: range.location - numberString.count, length: 0)
                                return false
                            }
                        }
                    }
                }
            }

            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.allowsEditingTextAttributes = false
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.font = getFont() // Set initial font
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        // Update font if needed
        uiView.font = getFont()
    }
    
    private func getFont() -> UIFont {
        let size: CGFloat
        switch fontSize {
        case "Small":
            size = 14
        case "Large":
            size = 23
        default:
            size = 17
        }
        
        switch font {
        case "Helvetica":
            return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
        case "Courier":
            return UIFont(name: "Courier", size: size) ?? UIFont.systemFont(ofSize: size)
        default:
            return UIFont(name: "Arial", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}
