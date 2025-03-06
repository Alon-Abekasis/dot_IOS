struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Privacy Policy")
                    .font(.title)
                // Your privacy policy content here
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}