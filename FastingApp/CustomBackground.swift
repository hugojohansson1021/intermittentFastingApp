//
//  CustomBackground.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2024-01-09.
//

import SwiftUI

struct CustomBackground: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        LinearGradient(gradient: Gradient(colors: userSettings.selectedGradient.colors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

