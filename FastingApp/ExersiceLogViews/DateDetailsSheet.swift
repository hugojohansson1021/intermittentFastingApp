//
//  DateDetailsSheet.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2024-01-09.
//

import SwiftUI
import CoreData


struct DateDetailsSheet: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var userSettings: UserSettings
    var markedDate: MarkedDate?
    var date: Date
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var selectedColor: String = "Red"
    
    let colorChoices = [
        "Blue": Color("blueBack"),
        "Red": Color.red,
        "Yellow": Color.yellow,
        "Green": Color.green,
        "Pink": Color("PinkLink")
    ]

    
    
    var body: some View {
        
        
        ZStack{
            
            CustomBackground()
            
            
            VStack(spacing: 5) {
                
                Text("Titel")
                    .font(.title2)
                    
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .cornerRadius(5)
                
                Text("Note")
                    .font(.title2)
    
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                TextEditor(text: $note)
                    .frame(minHeight: 80, maxHeight: 100)
                    .cornerRadius(5)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.1))
                    .cornerRadius(5)


                
                HStack {
                    ForEach(colorChoices.keys.sorted(), id: \.self) { colorName in
                        Button(action: {
                            selectedColor = colorName
                        }) {
                            Circle()
                                .fill(colorChoices[colorName]!)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle().stroke(selectedColor == colorName ? Color.white : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
                
                
                
                
                
                Button("Save") {
                    saveData()
                    isPresented = false
                }
                
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)
                
                // Deletae-knappen
                if markedDate != nil {
                    Button("Delete") {
                        deleteMarkedDate()
                    }
                    
                    
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .foregroundColor(.red)
                }
            }
            .onAppear {
                if let existingData = markedDate {
                    title = existingData.title ?? ""
                    note = existingData.note ?? ""
                    selectedColor = existingData.color ?? "Red"
                }
            }
        }.environment(\.colorScheme, .light) // HårdK light mode
        
    }

    private func saveData() {
        let markedDateToUpdate = markedDate ?? MarkedDate(context: viewContext)
        markedDateToUpdate.title = self.title
        markedDateToUpdate.note = self.note
        markedDateToUpdate.color = self.selectedColor

        if markedDate == nil {
            markedDateToUpdate.date = date
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }


    private func deleteMarkedDate() {
        if let markedDateToDelete = markedDate {
            viewContext.delete(markedDateToDelete)
            try? viewContext.save()
            isPresented = false
        }
    }
}




