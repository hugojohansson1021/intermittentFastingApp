//
//  WeightEntrySheet.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//
import SwiftUI
import CoreData

struct WeightEntrySheet: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var hundreds: Int = 0
    @State private var tens: Int = 0
    @State private var ones: Int = 0
    @State private var tenths: Int = 0
    @State private var date = Date()

    var weight: Double {
        Double(hundreds * 100 + tens * 10 + ones) + Double(tenths) / 10.0
    }

    var formattedWeight: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        
        return formatter.string(from: NSNumber(value: weight)) ?? "N/A kg/Lbs"
    }

    init(initialWeight: Double) {
        _hundreds = State(initialValue: Int(initialWeight / 100))
        _tens = State(initialValue: Int((initialWeight / 10).truncatingRemainder(dividingBy: 10)))
        _ones = State(initialValue: Int(initialWeight.truncatingRemainder(dividingBy: 10)))
        _tenths = State(initialValue: Int((initialWeight * 10).truncatingRemainder(dividingBy: 10)))
    }

    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground() // Ersätt med din egna bakgrund

                VStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.white)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                    
                    Text("Weight: \(formattedWeight)")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack {
                        CustomPickerView(selection: $hundreds, range: 0...9)
                        CustomPickerView(selection: $tens, range: 0...9)
                        CustomPickerView(selection: $ones, range: 0...9)
                        Text(".")
                        CustomPickerView(selection: $tenths, range: 0...9)
                        Text("kg")
                            .font(.largeTitle)
                    }
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .frame(height: 200)
                    
                    Button("Save") {
                        let newWeightEntry = CDWeightEntry(context: managedObjectContext)
                        newWeightEntry.weight = weight
                        newWeightEntry.date = date
                        
                        do {
                            try managedObjectContext.save()
                            dismiss()
                        } catch {
                            print("Error saving weight: \(error)")
                        }
                    }
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Add Weight")
                .navigationBarTitleDisplayMode(.inline)
            }
            .environment(\.colorScheme, .light)
        }
    }

    struct CustomPickerView: View {
        @Binding var selection: Int
        let range: ClosedRange<Int>
        
        var body: some View {
            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            // Topp padding för att centrera den initiala visningen
                            Spacer(minLength: geometry.size.height / 2 - 20) // Justera detta värde om nödvändigt
                            
                            ForEach(range, id: \.self) { number in
                                Text("\(number)")
                                    .font(.headline)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, maxHeight: 40) // Kontrollera att detta matchar din cellhöjd
                                    .background(selection == number ? Color.white.opacity(0.5) : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        withAnimation {
                                            selection = number
                                            scrollViewProxy.scrollTo(selection, anchor: .center)
                                        }
                                    }
                                    .id(number)
                            }
                            
                            // Botten padding för att centrera den initiala visningen
                            Spacer(minLength: geometry.size.height / 2 - 20) // Justera detta värde om nödvändigt
                        }
                    }
                    .onAppear {
                        scrollViewProxy.scrollTo(selection, anchor: .center)
                    }
                }
                .frame(height: geometry.size.height)
            }
            .frame(height: 150) // Eller vilken höjd som bäst passar din layout
        }
    }

}

func fetchLastWeight(managedObjectContext: NSManagedObjectContext) -> Double {
    let request: NSFetchRequest<CDWeightEntry> = CDWeightEntry.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \CDWeightEntry.date, ascending: false)]
    request.fetchLimit = 1

    do {
        let result = try managedObjectContext.fetch(request)
        return result.first?.weight ?? 0.0
    } catch {
        print("Error fetching last weight: \(error)")
        return 0.0
    }
}

struct WeightEntrySheet_Previews: PreviewProvider {
    static var previews: some View {
        WeightEntrySheet(initialWeight: 0.0)
            .environmentObject(UserSettings())
    }
}

extension Color {
    static let customDarkPurple = Color("darkPurple")
    static let customPurpleDark = Color("purpleDark")
    static let customDarkPink = Color("darkPink")
}

