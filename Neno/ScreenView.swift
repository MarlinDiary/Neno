//
//  ScreenView.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI
import StoreKit

struct ScreenView: View {
    @AppStorage("confirmDelete") private var confirmDelete = false
    @State private var showingAlert = false
    @State private var deleteSensorTrigger = false
    @State private var copySensorTrigger = false
    @Environment(\.colorScheme) var colorScheme
    @FocusState.Binding var focusedField: Int?
    @Binding var text: String
    @Binding var pageID: Int
    @Binding var infoisOn: Bool
    var thisPageID: Int
    var strokeColor: String = "#72746D"
    var screenColor: String = "#B1B39D"
    var darkscreenColor: String = "#3C262E"
    var cornerRadius: CGFloat = 10

    var characterCount: Int {
        text.count
    }

    var wordCount: Int {
        text.split { !$0.isLetter }.count
    }

    var paragraphCount: Int {
        text.split(separator: "\n").count
    }

    var body: some View {
        ZStack {
            // Background and Screen design
            if colorScheme == .light {
                // Light mode background
                lightModeBackground
            } else {
                // Dark mode background
                darkModeBackground
            }

            // TextView
            VStack(spacing: 0){
                TextViewWrapper(text: $text)
                    .focused($focusedField, equals: thisPageID)
                    .opacity(0.6)
                    .tint(colorScheme == .light ? .black.opacity(0.7): .white.opacity(0.7))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            
            // Info View
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: colorScheme == .light ? cornerRadius + 1: cornerRadius + 4, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        ScrollView{
                            VStack(spacing: 0){
                                infoView
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                SettingView(infoisOn: $infoisOn, strokeColor: strokeColor, deleteSensorTrigger: $deleteSensorTrigger, copySensorTrigger: $copySensorTrigger)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                contactView
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                            }
                        }.scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                    }
            }
            .padding(.top, colorScheme == .light ? 12: 9)
            .padding(.leading, colorScheme == .light ? 12: 9)
            .padding(.trailing, colorScheme == .light ? 12: 9)
            .padding(.bottom, colorScheme == .light ? 12: 11)
            .opacity(infoisOn ? 1: 0)
            .animation(.spring.speed(5), value: infoisOn)
        }
        .padding(.horizontal)
        .alert("Clear Content", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {text = ""}
        }
    }

    var lightModeBackground: some View {
        ZStack {
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
        }
    }

    var darkModeBackground: some View {
        ZStack {
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
    }

    var infoView: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Info View
                HStack {
                    Text("Information")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            infoisOn.toggle()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .rotationEffect(infoisOn ? .zero : .degrees(90))
                    }
                }
                .font(.title2.bold())
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    HStack {
                        Image(systemName: "character.duployan")
                        Text("Characters: \(characterCount)")
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "number")
                        Text("Words: \(wordCount)")
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "paragraphsign")
                        Text("Paragraphs: \(paragraphCount)")
                    }
                }
                //.font(.callout)
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    Button(action: {
                        UIPasteboard.general.string = text
                        copySensorTrigger.toggle()
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy to Clipboard")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = text
                        copySensorTrigger.toggle()
                        text = ""
                    }) {
                        HStack {
                            Image(systemName: "doc.on.clipboard")
                            Text("Cut to Clipboard")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    ShareLink(item: text) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share to Other Applications")
                        }
                    }
                    Spacer()
                    Button(action: {
                        if confirmDelete {
                            showingAlert.toggle()
                            deleteSensorTrigger.toggle()
                        } else {
                            text = ""
                            deleteSensorTrigger.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear Content")
                        }
                        .foregroundStyle(.red.opacity(0.6))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                //.disabled(text.trimmingCharacters(in: .whitespacesAndNewlines)=="")
                //.font(.title3)
            }
            .foregroundStyle(Color(hex: strokeColor))
            .padding()
            .sensoryFeedback(.warning, trigger: deleteSensorTrigger)
            .sensoryFeedback(.success, trigger: copySensorTrigger)
        }
        .padding(.top, colorScheme == .light ? 12: 9)
        .padding(.leading, colorScheme == .light ? 12: 9)
        .padding(.trailing, colorScheme == .light ? 12: 9)
        .padding(.bottom, colorScheme == .light ? 12: 11)
    }
    
    var contactView: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Info View
                HStack {
                    Text("Others")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            infoisOn.toggle()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .rotationEffect(infoisOn ? .zero : .degrees(90))
                    }
                }
                .font(.title2.bold())
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    Button(action: {
                        copySensorTrigger.toggle()
                        let email = "developer@huizha.com"
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Email")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let url = URL(string: "https://twitter.com/marlindiary") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Twitter")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let url = URL(string: "https://www.instagram.com/deerspost") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Instagram")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let url = URL(string: "https://m.weibo.cn/u/7873964072?uid=7873964072&t=userinfo&_T_WM=8b0dc5da0300bddb0302ab361a1ba629") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "eye")
                            Text("Weibo")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let url = URL(string: "https://noufou.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Website")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                Divider()
                Spacer()
                
                Group {
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let url = URL(string: "https://github.com/MarlinDiary/Neno") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "star")
                            Text("Star on GitHub")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                               SKStoreReviewController.requestReview(in: scene)
                                           }
                    }) {
                        HStack {
                            Image(systemName: "heart")
                            Text("Rate Neno")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    /*
                    Spacer()
                    Button(action: {
                        copySensorTrigger.toggle()
                        // Add action to buy a cup of coffee
                        // Replace with appropriate link or functionality
                    }) {
                        HStack {
                            Image(systemName: "cup.and.saucer")
                            Text("Buy Me a Cup of Coffee")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                     */
                }
            }
            .foregroundStyle(Color(hex: strokeColor))
            .padding()
            .sensoryFeedback(.warning, trigger: deleteSensorTrigger)
            .sensoryFeedback(.success, trigger: copySensorTrigger)
        }
        .padding(.top, colorScheme == .light ? 12 : 9)
        .padding(.leading, colorScheme == .light ? 12 : 9)
        .padding(.trailing, colorScheme == .light ? 12 : 9)
        .padding(.bottom, colorScheme == .light ? 12 : 11)
    }
}
