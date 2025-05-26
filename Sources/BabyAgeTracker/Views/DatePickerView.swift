import SwiftUI

public struct DatePickerView: View {
    @ObservedObject var viewModel: BabyAgeViewModel
    @State private var babyName: String = ""
    @State private var birthDate: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    public init(viewModel: BabyAgeViewModel) {
        self.viewModel = viewModel
        
        // Initialize with existing values if available
        if let baby = viewModel.baby {
            _babyName = State(initialValue: baby.name)
            _birthDate = State(initialValue: baby.birthDate)
        }
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Baby Information")) {
                    TextField("Baby's Name", text: $babyName)
                        .accessibilityLabel("Baby's Name")
                    
                    DatePicker(
                        "Birth Date",
                        selection: $birthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .accessibilityLabel("Birth Date")
                }
                
                Section {
                    if viewModel.baby != nil {
                        Button("Update") {
                            saveChanges()
                        }
                        .accessibilityLabel("Update baby information")
                    } else {
                        Button("Save") {
                            saveChanges()
                        }
                        .accessibilityLabel("Save baby information")
                    }
                }
            }
            .navigationTitle("Baby Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        let baby = BabyModel(
            id: viewModel.baby?.id ?? UUID(),
            name: babyName,
            birthDate: birthDate
        )
        
        viewModel.saveBaby(baby)
        presentationMode.wrappedValue.dismiss()
    }
}
