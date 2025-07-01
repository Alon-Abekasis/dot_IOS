import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Our Privacy Policy was last updated on February 5th, 2025.")
                    .font(.subheadline)
                
                Group {
                    Text("This Privacy Policy describes our policies and procedures on the collection, use, and disclosure of your information when you use Dot SAGA LTD's app and website and informs you about your privacy rights and how the law protects you.")
                    
                    Text("We use your personal data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this Privacy Policy.")
                }
                
                Group {
                    Text("Interpretation and Definitions")
                        .font(.title2)
                        .bold()
                    
                    Text("Interpretation")
                        .font(.title3)
                        .bold()
                    
                    Text("Words with capitalized initial letters have meanings defined under the following conditions. These definitions apply whether the terms appear in singular or plural.")
                }
                
                Group {
                    Text("Definitions")
                        .font(.title3)
                        .bold()
                    
                    Text("For the purposes of this Privacy Policy:")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint("Account: A unique account created for you to access our Service.")
                        BulletPoint("Business: As defined by the CCPA, refers to Dot SAGA LTD that collects consumers' personal information and determines the processing purposes.")
                        BulletPoint("Company: Refers to Dot SAGA LTD (\"the Company,\" \"We,\" \"Us,\" or \"Our\").")
                        BulletPoint("Country: Refers to Israel.")
                        BulletPoint("Consumer: For the CCPA, a natural person who is a California resident.")
                        BulletPoint("Cookies: Small files placed on your device by a website to store browsing information.")
                        // ... continue with other definitions ...
                    }
                }
                
                // Continue with other sections...
                Group {
                    Text("Collecting and Using Your Personal Data")
                        .font(.title2)
                        .bold()
                    
                    Text("Types of Data Collected")
                        .font(.title3)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint("Personal Data: Includes email address, name, phone number, address, and usage data.")
                        BulletPoint("Usage Data: Automatically collected information such as IP address, browser type, pages visited, and device identifiers.")
                    }
                }
                
                // Add remaining sections similarly...
                
                Group {
                    Text("Contact Us")
                        .font(.title2)
                        .bold()
                    
                    Text("If you have questions about this Privacy Policy:")
                    
                    HStack {
                        Text("By sending us an email: ")
                        Link("Contact@dotsaga.live", destination: URL(string: "mailto:Contact@dotsaga.live")!)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

// Helper view for bullet points
struct BulletPoint: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .padding(.trailing, 5)
            Text(text)
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
