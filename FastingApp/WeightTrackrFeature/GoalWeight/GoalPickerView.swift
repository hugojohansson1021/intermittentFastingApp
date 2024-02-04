//
//  GoalPickerView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-02.
//

import SwiftUI

struct CustomPickerView: View {
    @Binding var selection: Int
    let range: ClosedRange<Int>

    var body: some View {
        ScrollView {
            VStack() {
                ForEach(range, id: \.self) { number in
                    Text("\(number)")
                        .font(.headline)
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)) // Minskat padding
                                                
                        .frame(maxWidth: .infinity)
                        .background(self.selection == number ? Color.white.opacity(0.5) : Color.clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.selection = number
                        }
                }
            }
        }
    }
}

struct GoalPickerView: View {
    @State private var localSelection: Int
    var initialGoalWeight: Int
    var onSave: (Int) -> Void
    @Environment(\.presentationMode) var presentationMode

    init(initialGoalWeight: Int, onSave: @escaping (Int) -> Void) {
        self.initialGoalWeight = initialGoalWeight
        _localSelection = State(initialValue: initialGoalWeight)
        self.onSave = onSave
    }

    var body: some View {
        ZStack {
            CustomBackground()

            VStack {
                Text("Choose a goal Weight")
                    .font(.title)
                    .padding()
                    .foregroundStyle(.white)
                    .fontWeight(.bold)

                CustomPickerView(selection: $localSelection, range: 50...350)
                    .frame(height: 200)
                    .clipped()
                    .accentColor(.white)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                    .onChange(of: localSelection) { newValue in
                        print("Picker nuvarande val: \(newValue)")
                    }

                Button("Save") {
                    presentationMode.wrappedValue.dismiss()
                    onSave(localSelection)
                }
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)

                Spacer()
            }
        }
        .environment(\.colorScheme, .light)
        .onAppear {
            localSelection = initialGoalWeight
        }
    }
}

struct GoalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GoalPickerView(initialGoalWeight: 60) { selectedWeight in
            print("Valt vikt för förhandsvisning: \(selectedWeight)")
        }
        .environmentObject(UserSettings())
    }
}


