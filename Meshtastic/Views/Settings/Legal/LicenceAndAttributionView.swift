struct LicenseAgreementsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("License Agreements")
                    .font(.title)
                // Your license agreements content here
            }
            .padding()
        }
        .navigationTitle("License Agreements")
    }
}