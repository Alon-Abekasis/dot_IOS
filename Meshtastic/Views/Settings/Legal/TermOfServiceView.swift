struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Terms of Service")
                    .font(.title)
                // Your terms content here
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
    }
}