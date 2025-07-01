import SwiftUI

struct LicenceAndAttributionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Attribution Section
                Group {
                    Text("Attribution")
                        .font(.title)
                        .bold()
                    
                    Text("This service would not be possible without the incredible work of the Meshtastic open-source community. Thank you, Meshtastic.")
                }
                
                // License Section
                Group {
                    Text("License")
                        .font(.title)
                        .bold()
                    
                    Text("Apache License, Version 2.0")
                        .font(.title2)
                    
                    Text("Apache License\nVersion 2.0, January 2004")
                    
                    Link("http://www.apache.org/licenses/", 
                         destination: URL(string: "http://www.apache.org/licenses/")!)
                        .foregroundColor(.blue)
                    
                    Text("TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION")
                        .font(.headline)
                        .padding(.vertical)
                    
                    Text("1. Definitions.")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("""
                            "License" shall mean the terms and conditions for use, reproduction, \
                            and distribution as defined by Sections 1 through 9 of this document.
                            
                            "Licensor" shall mean the copyright owner or entity authorized by \
                            the copyright owner that is granting the License.
                            
                            "Legal Entity" shall mean the union of the acting entity and all \
                            other entities that control, are controlled by, or are under common \
                            control with that entity. For the purposes of this definition, \
                            "control" means (i) the power, direct or indirect, to cause the \
                            direction or management of such entity, whether by contract or \
                            otherwise, or (ii) ownership of fifty percent (50%) or more of the \
                            outstanding shares, or (iii) beneficial ownership of such entity.
                            
                            "You" (or "Your") shall mean an individual or Legal Entity \
                            exercising permissions granted by this License.
                            
                            "Source" form shall mean the preferred form for making modifications, \
                            including but not limited to software source code, documentation \
                            source, and configuration files.
                            
                            "Object" form shall mean any form resulting from mechanical \
                            transformation or translation of a Source form, including but \
                            not limited to compiled object code, generated documentation, \
                            and conversions to other media types.
                            
                            "Work" shall mean the work of authorship, whether in Source or \
                            Object form, made available under the License.
                            """)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("License & Attribution")
    }
}

#Preview {
    NavigationStack {
        LicenceAndAttributionView()
    }
}
