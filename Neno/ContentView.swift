//
//  ContentView.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var texts: [String] = ["","","","",""]
    var strokeColors = ["#817B7B","#807D79","#787D7F", "#72746D", "#7E7C82"]
    var screenColors = ["#C4ADB5","#C0B0A8","#A2B5B8", "#B1B39D", "#B1B0C0"]
    var darkscreenColors = ["#3C262E","#472E22","#13272A","#23250F","#252534"]
    var tappedColors = [Color(hex: "#D55984"),Color(hex: "#F47738"),Color(hex: "#AEDAE1"),Color(hex: "#E2EC7C"),Color(hex: "#B44EFF")]
    var untappedColors = [Color(hex: "#C4ADB5"),Color(hex: "#C0B0A8"),Color(hex: "#A2B5B8"),Color(hex: "#B1B39D"),Color(hex: "#AAA8C8")]
    @AppStorage("Page") var pageID: Int = 0
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            Color(hex: colorScheme == .light ? "#D1D3D9": "#1D1E1F")
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    ZStack(alignment: .topLeading){
                        Color(hex: colorScheme == .light ? "#CFD3D9": "#323333")
                            .ignoresSafeArea(edges: .top)
                        Image("NoiseGradient")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.4)
                            .ignoresSafeArea()
                    }
                }
            VStack(spacing: 0){
                HStack {
                    ForEach(0..<5) {id in
                        Spacer()
                        ButtonView(text: $texts[id], focusedField: $focusedField, pageID: $pageID, radius: 10, untappedColor: tappedColors[id], tappedColor: untappedColors[id], thisPageID: id)
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.bottom)
                TabView(selection: $pageID) {
                    ForEach(0..<5) {id in
                        ScreenView(focusedField: $focusedField, text: $texts[id], pageID: $pageID, thisPageID: id,strokeColor: strokeColors[id],screenColor: screenColors[id], darkscreenColor: darkscreenColors[id])
                            .overlay {
                                GeometryReader { geometry in
                                    Circle()
                                        .frame(width: 100)
                                        .opacity(0)
                                        .onChange(of: geometry.frame(in: .global).minX) { oldValue, newValue in
                                            print(newValue)
                                            if newValue == UIScreen.main.bounds.width {
                                                focusedField = id-1
                                            } else if newValue == -UIScreen.main.bounds.width {
                                                focusedField = id + 1
                                            }
                                        }
                                }
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .onAppear {
                    UIPageControl.appearance().isHidden = true
                    focusedField = pageID
                    loadTexts()
                }
                .onChange(of: texts) { oldValue, newValue in
                    saveTexts()
                }
                .onChange(of: pageID, { oldValue, newValue in
                    //focusedField = pageID
                })
                .sensoryFeedback(.increase, trigger: pageID)
            }
        }
    }
    
    func saveTexts() {
        for (index, text) in texts.enumerated() {
            UserDefaults.standard.set(text, forKey: "Text\(index)")
        }
    }
    
    func loadTexts() {
        for index in 0..<texts.count {
            texts[index] = UserDefaults.standard.string(forKey: "Text\(index)") ?? ""
        }
    }
}

#Preview {
    ContentView()
}
