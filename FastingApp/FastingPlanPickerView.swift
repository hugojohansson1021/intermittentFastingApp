//
//  FastingPlanPickerView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-19.
//

import SwiftUI

struct FastingPlanPickerView: View {
    @Binding var selectedFastingPlan: FastingPlan

    var body: some View {
        VStack {
            Picker("Select Fasting Plan", selection: $selectedFastingPlan) {
                Text(FastingPlan.beginner.rawValue).tag(FastingPlan.beginner)
                Text(FastingPlan.intermediate.rawValue).tag(FastingPlan.intermediate)
                Text(FastingPlan.advanced.rawValue).tag(FastingPlan.advanced)
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    FastingPlanPickerView()
}
