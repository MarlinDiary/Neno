//
//  ContentView.swift
//  Neno
//
//  Created by Drawix on 2024/6/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var texts: [String] = ["", "", "", "", "", "", ""]
    @State private var lastSyncDate: Date?
    @AppStorage("iCloudSync") private var iCloudSync = true // 从 UserDefaults 读取 iCloud 同步状态
    var strokeColors = ["#817B7B", "#817B7B", "#817B7B", "#817B7B", "#817B7B", "#817B7B", "#817B7B"]
    var screenColors = ["C4ADAD", "C0B0A8", "C2B598", "AAB39D", "A2B8B5", "96ABB7", "BAB0C0"]
    var darkscreenColors = ["3C2626", "472E22", "473F22", "2F4722", "13272A", "13192A", "2E2534"]
    var tappedColors = [Color(hex: "E73737"), Color(hex: "F47738"), Color(hex: "F4B438"), Color(hex: "29EA11"), Color(hex: "78E3E9"), Color(hex: "7AC5FE"), Color(hex: "B44EFF")]
    var untappedColors = [Color(hex: "C4ADAD"), Color(hex: "C0B0A8"), Color(hex: "C2B598"), Color(hex: "AAB39D"), Color(hex: "A2B8B5"), Color(hex: "96ABB7"), Color(hex: "BAB0C0")]
    var darkuntappedColors = [Color(hex: "3C2626"), Color(hex: "472E22"), Color(hex: "473F22"), Color(hex: "2F4722"), Color(hex: "13272A"), Color(hex: "13192A"), Color(hex: "2E2534")]
    @AppStorage("Page") var pageID: Int = 0
    @FocusState private var focusedField: Int?
    @State private var showBlur = false
    @State private var infoisOn = false
    
    var body: some View {
        ZStack {
            ZStack {
                Color(hex: colorScheme == .light ? "#D1D3D9" : "#1D1E1F")
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        ZStack(alignment: .topLeading) {
                            Color(hex: colorScheme == .light ? "#CFD3D9" : "#323333")
                                .ignoresSafeArea(edges: .top)
                            Image("NoiseGradient")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.4)
                                .ignoresSafeArea()
                        }
                    }
                
                if showBlur {
                    LaunchScreenView()
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack(spacing: 0) {
                    HStack {
                        ForEach(0..<7) { id in
                            ButtonView(text: $texts[id], focusedField: $focusedField, pageID: $pageID, radius: 10, untappedColor: tappedColors[id], darkuntappedColor: darkuntappedColors[id], tappedColor: untappedColors[id], thisPageID: id)
                            Spacer()
                        }
                        InfoButtonView(radius: 10, isTapped: $infoisOn)
                    }
                    .opacity(showBlur ? 0 : 1)
                    .padding(.horizontal, 33)
                    .padding(.bottom)
                    
                    TabView(selection: $pageID) {
                        ForEach(0..<7) { id in
                            ScreenView(focusedField: $focusedField, text: $texts[id], pageID: $pageID, infoisOn: $infoisOn, thisPageID: id, strokeColor: strokeColors[id], screenColor: screenColors[id], darkscreenColor: darkscreenColors[id])
                                .opacity(showBlur ? 0 : 1)
                                .overlay {
                                    Image("LaunchImage")
                                        .opacity(showBlur ? 1 : 0)
                                    GeometryReader { geometry in
                                        Circle()
                                            .frame(width: 100)
                                            .opacity(0)
                                            .onChange(of: geometry.frame(in: .global).minX) { oldValue, newValue in
                                                print(newValue)
                                                if newValue == 0 {
                                                    focusedField = pageID
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
                        startObservingiCloudChanges()
                    }
                    .onChange(of: texts) { oldValue, newValue in
                        saveTexts()
                        lastSyncDate = Date()
                        saveSyncDate()
                    }
                    .onChange(of: pageID) { oldValue, newValue in
                        // focusedField = pageID
                    }
                    .sensoryFeedback(.increase, trigger: pageID)
                    .sensoryFeedback(.increase, trigger: infoisOn)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            showBlur = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            showBlur = false
        }
    }
    
    func saveTexts() {
        if iCloudSync {
            let store = NSUbiquitousKeyValueStore.default
            for (index, text) in texts.enumerated() {
                store.set(text, forKey: "Text\(index)")
            }
            store.synchronize()
        } else {
            let store = UserDefaults.standard
            for (index, text) in texts.enumerated() {
                store.set(text, forKey: "Text\(index)")
            }
            store.synchronize()
        }
    }
    
    func loadTexts() {
        if iCloudSync {
            let store = NSUbiquitousKeyValueStore.default
            for index in 0..<texts.count {
                texts[index] = store.string(forKey: "Text\(index)") ?? ""
            }
            lastSyncDate = store.object(forKey: "LastSyncDate") as? Date
        } else {
            let store = UserDefaults.standard
            for index in 0..<texts.count {
                texts[index] = store.string(forKey: "Text\(index)") ?? ""
            }
            lastSyncDate = store.object(forKey: "LastSyncDate") as? Date
        }
    }
    
    func saveSyncDate() {
        if iCloudSync {
            let store = NSUbiquitousKeyValueStore.default
            store.set(Date(), forKey: "LastSyncDate")
            store.synchronize()
        } else {
            let store = UserDefaults.standard
            store.set(Date(), forKey: "LastSyncDate")
            store.synchronize()
        }
    }
    
    func startObservingiCloudChanges() {
        guard iCloudSync else { return }
        NotificationCenter.default.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default, queue: .main) { _ in
            self.loadTexts()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
