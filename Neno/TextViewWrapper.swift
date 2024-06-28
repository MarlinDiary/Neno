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
    @AppStorage("paragraphSpacing") private var paragraphSpacing = "Small" // Small, Medium, Large

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
        textView.font = getFontSize() // Set initial font size
        textView.attributedText = getAttributedText(text: text, fontSize: getFontSize()) // Set initial attributed text
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.attributedText = getAttributedText(text: text, fontSize: getFontSize())
        }
        
        // Update font size if needed
        uiView.font = getFontSize()
        // Always update attributedText to ensure paragraph spacing is applied
        uiView.attributedText = getAttributedText(text: text, fontSize: getFontSize())
    }
    
    private func getFontSize() -> UIFont {
        switch fontSize {
        case "Small":
            return UIFont.systemFont(ofSize: 14)
        case "Large":
            return UIFont.systemFont(ofSize: 23)
        default:
            return UIFont.systemFont(ofSize: 17)
        }
    }

    private func getParagraphSpacing() -> CGFloat {
        switch paragraphSpacing {
        case "Medium":
            return 8.0
        case "Large":
            return 16.0
        default:
            return 0.0
        }
    }

    private func getAttributedText(text: String, fontSize: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = getParagraphSpacing()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: fontSize,
            .paragraphStyle: paragraphStyle
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }
}
