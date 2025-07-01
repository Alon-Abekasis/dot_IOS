import SwiftUI

struct TermOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Introduction
                Group {
                    Text("Our Terms and Conditions were last updated on February 5th, 2025.")
                        .font(.subheadline)
                    
                    Text("Please read these Terms and Conditions carefully before using Dot SAGA LTD's app and website.")
                }
                
                // Interpretation and Definitions
                Group {
                    Text("Interpretation and Definitions")
                        .font(.title2)
                        .bold()
                    
                    Text("Interpretation")
                        .font(.title3)
                        .bold()
                    
                    Text("Words with capitalized initial letters have meanings defined under the following conditions. These definitions apply whether the terms appear in singular or plural.")
                }
                
                // Definitions
                Group {
                    Text("Definitions")
                        .font(.title3)
                        .bold()
                    
                    Text("For the purposes of these Terms and Conditions:")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint("Affiliate: An entity that controls, is controlled by, or is under common control with a party.")
                        BulletPoint("Account: A unique account created for you to access our Service.")
                        BulletPoint("Company: Refers to Dot SAGA LTD (\"the Company,\" \"We,\" \"Us,\" or \"Our\").")
                        BulletPoint("Country: Refers to Israel.")
                        BulletPoint("Content: Text, images, or other information that can be posted, uploaded, or linked by you.")
                        BulletPoint("Device: Any device that can access the Service, such as a computer, phone, or tablet.")
                        BulletPoint("Feedback: Feedback, innovations, or suggestions you send regarding the Service.")
                        BulletPoint("Products: Items offered for sale on the Service.")
                        BulletPoint("Orders: Requests by you to purchase Products from us.")
                        BulletPoint("Promotions: Contests, sweepstakes, or promotions offered through the Service.")
                        BulletPoint("Service: Refers to Dot SAGA LTD's app and website.")
                        BulletPoint("Terms and Conditions: These Terms that form the entire agreement between you and the Company.")
                        BulletPoint("Third-party Social Media Service: Any services or content provided by a third party through the Service.")
                        BulletPoint("Website: Refers to Dot SAGA LTD's website, accessible from www.dotsaga.live.")
                        BulletPoint("You: The individual accessing or using the Service.")
                    }
                }
                
                // Acknowledgment
                Group {
                    Text("Acknowledgment")
                        .font(.title2)
                        .bold()
                    
                    Text("These Terms and Conditions govern the use of the Service and set out the rights and obligations of all users. By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of these Terms, you may not access the Service.")
                    
                    Text("You represent that you are over 18 years old. Dot SAGA LTD does not permit those under 18 to use the Service.")
                    
                    Text("Your use of the Service is also conditioned on your acceptance of our Privacy Policy. Please read it carefully before using our Service.")
                }
                
                // User Accounts
                Group {
                    Text("User Accounts")
                        .font(.title2)
                        .bold()
                    
                    Text("When creating an account, you must provide accurate, complete, and current information. You are responsible for safeguarding your password and any activities under your account.")
                    
                    Text("You may not use a username that belongs to someone else without proper authorization or any name that is offensive, vulgar, or obscene.")
                }
                
                // Content
                Group {
                    Text("Content")
                        .font(.title2)
                        .bold()
                    
                    Text("Your Right to Post Content")
                        .font(.title3)
                        .bold()
                    
                    Text("By posting content on the Service, you grant Dot SAGA LTD the right to use, modify, publicly display, reproduce, and distribute it. You retain ownership of your content but must ensure it does not violate any laws or third-party rights.")
                    
                    Text("Content Restrictions")
                        .font(.title3)
                        .bold()
                    
                    Text("You may not post content that is:")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        BulletPoint("Unlawful or promoting illegal activities.")
                        BulletPoint("Defamatory, discriminatory, or offensive.")
                        BulletPoint("Spam or unauthorized advertising.")
                        BulletPoint("Harmful software or malware.")
                        BulletPoint("Infringing on intellectual property rights.")
                        BulletPoint("Impersonating others.")
                        BulletPoint("Violating privacy rights.")
                    }
                    
                    Text("The Company reserves the right to remove content that violates these Terms.")
                }
                
                // Copyright and Orders
                Group {
                    Text("Copyright Policy")
                        .font(.title2)
                        .bold()
                    
                    Text("We respect intellectual property rights. If you believe your copyrighted work has been infringed, contact us at Contact@dotsaga.live with detailed information about the infringement.")
                    
                    Text("Placing Orders for Products")
                        .font(.title2)
                        .bold()
                    
                    Text("By placing an order, you warrant that you have the legal right to do so. You may be asked to provide payment information, and you represent that all provided information is accurate.")
                    
                    Text("We reserve the right to cancel orders due to errors or suspected fraud.")
                }
                
                // Prices and Promotions
                Group {
                    Text("Prices and Payments")
                        .font(.title2)
                        .bold()
                    
                    Text("Prices are subject to change without notice. Payments can be made using various methods, including Visa, MasterCard, or online options like PayPal.")
                    
                    Text("Promotions")
                        .font(.title2)
                        .bold()
                    
                    Text("Promotions offered through the Service may have separate rules. If they conflict with these Terms, the promotion rules will apply.")
                }
                
                // Legal Sections
                Group {
                    Text("Intellectual Property")
                        .font(.title2)
                        .bold()
                    
                    Text("The Service and its content, excluding content provided by users, are the property of Dot SAGA LTD and its licensors. You may not use our trademarks without prior written consent.")
                    
                    Text("Links to Other Websites")
                        .font(.title2)
                        .bold()
                    
                    Text("Our Service may link to third-party websites. We are not responsible for their content or privacy practices. Please review their terms before using.")
                    
                    Text("Termination")
                        .font(.title2)
                        .bold()
                    
                    Text("We may suspend or terminate your account for violating these Terms. Upon termination, your right to use the Service ceases immediately.")
                }
                
                // Liability and Legal
                Group {
                    Text("Limitation of Liability")
                        .font(.title2)
                        .bold()
                    
                    Text("Our liability is limited to the amount you paid for the Service or $100 if no payment was made. We are not liable for indirect or consequential damages.")
                    
                    Text("Disclaimer")
                        .font(.title2)
                        .bold()
                    
                    Text("The Service is provided \"AS IS\" without warranties of any kind. We do not guarantee the Service will be uninterrupted, error-free, or secure.")
                    
                    Text("Governing Law")
                        .font(.title2)
                        .bold()
                    
                    Text("These Terms are governed by the laws of Israel. Any disputes will be resolved under Israeli law.")
                }
                
                // Changes and Contact
                Group {
                    Text("Changes to These Terms")
                        .font(.title2)
                        .bold()
                    
                    Text("We reserve the right to modify these Terms. We will notify you of any material changes at least 30 days before they take effect. Continued use of the Service means you accept the new Terms.")
                    
                    Text("Contact Us")
                        .font(.title2)
                        .bold()
                    
                    Text("If you have any questions about these Terms and Conditions:")
                    
                    HStack {
                        Text("By sending us an email: ")
                        Link("Contact@dotsaga.live", destination: URL(string: "mailto:Contact@dotsaga.live")!)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Terms and Conditions")
    }
}

#Preview {
    NavigationStack {
        TermOfServiceView()
    }
}
