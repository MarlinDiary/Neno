//
//  ScreenView.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

struct ScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @FocusState.Binding var focusedField: Int?
    @Binding var text: String
    @Binding var pageID: Int
    var thisPageID: Int
    var strokeColor: String = "#72746D"
    var screenColor: String = "#B1B39D"
    var darkscreenColor: String = "#3C262E"
    var cornerRadius: CGFloat = 10
    var body: some View {
                 ZStack {
                     if colorScheme == .light {
                         RoundedRectangle(cornerRadius: cornerRadius + 13, style: .continuous)
                             .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(hex: "#B9BBC3").opacity(0.7), location: 0),
                                        .init(color: Color(hex: "#BEC4CA").opacity(0.9), location: 0.85),
                                        .init(color: Color(hex: "#E2E5E7"), location: 0.99)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .shadow(.inner(color: .gray.opacity(0.5), radius: 1, x: 0, y: 2))
                                .shadow(.inner(color: .white.opacity(0.9), radius: 0, x: 0, y: -2))
                             )
                         RoundedRectangle(cornerRadius: cornerRadius + 4, style: .continuous)
                             .fill(Color(hex: strokeColor).opacity(0.8))
                             .padding(9)
                         RoundedRectangle(cornerRadius: cornerRadius + 1, style: .continuous)
                             .fill(Color(hex: screenColor).opacity(1).gradient.shadow(.inner(color: .gray.opacity(0.5), radius: 30, x: 0, y: 0)))
                             .padding(12)
                         GeometryReader { geometry in
                             let rectangleHeight: CGFloat = 3.5
                             let numberOfRectangles = Int(geometry.size.height / rectangleHeight)
                             VStack(spacing: 0) {
                                 ForEach(0..<numberOfRectangles, id: \.self) { index in
                                     Rectangle()
                                         .fill(Color.gray.opacity(index % 2 == 0 ? 0 : 0.03))
                                         .frame(height: rectangleHeight)
                                 }
                             }
                         }
                         .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).padding(13))
                         .overlay {
                             RightAngledTrapezoid()
                                 .fill(
                                     LinearGradient(
                                         gradient: Gradient(stops: [
                                             .init(color: .black.opacity(0.01), location: 0),
                                             .init(color: .black.opacity(0), location: 1)
                                         ]),
                                         startPoint: .top,
                                         endPoint: .bottom
                                     )
                                 )
                                 .mask(RoundedRectangle(cornerRadius: cornerRadius + 13, style: .continuous))
                                 .allowsHitTesting(false)
                         }
                     } else {
                         RoundedRectangle(cornerRadius: cornerRadius + 13, style: .continuous)
                             .fill(Color(hex: "#070707").shadow(.inner(color: Color(hex: "#545454"), radius: 0, x: 0, y: -2)))
                         RoundedRectangle(cornerRadius: cornerRadius+4, style: .continuous)
                             .fill(Color(hex: darkscreenColor).opacity(1).shadow(.inner(color: .black.opacity(0.4), radius: 30, x: 0, y: 0)).shadow(.inner(color: Color(hex: "#505050").opacity(0.3), radius: 0, x: 0, y: 2)))
                             .padding(.top, 9)
                             .padding(.leading, 9)
                             .padding(.trailing, 9)
                             .padding(.bottom, 11)
                         GeometryReader { geometry in
                             let rectangleHeight: CGFloat = 3.5
                             let numberOfRectangles = Int(geometry.size.height / rectangleHeight)
                             VStack(spacing: 0) {
                                 ForEach(0..<numberOfRectangles, id: \.self) { index in
                                     Rectangle()
                                         .fill(Color.gray.opacity(index % 2 == 0 ? 0 : 0.02))
                                         .frame(height: rectangleHeight)
                                 }
                             }
                         }
                         .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).padding(.top, 9)
                            .padding(.leading, 9)
                            .padding(.trailing, 9)
                            .padding(.bottom, 11))
                     }
                     
                     TextViewWrapper(text: $text)
                         .focused($focusedField, equals: thisPageID)
                         .opacity(0.6)
                         .tint(colorScheme == .light ? .black.opacity(0.7): .white.opacity(0.7))
                         .padding(.horizontal, 15)
                         .padding(.vertical, 12)
                
            }
            .padding(.horizontal)
    }
}
