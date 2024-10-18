import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sharing & Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Last updated: March 22, 2024")
                    .foregroundColor(.gray)
                
                Text("Introduction")
                    .font(.headline)
                
                Text("This page is used to inform app visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decides to use our Service, the AIOFitness App.")
                
                Text("If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.")
                
                Text("The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at AIOFitness App, unless otherwise defined in this Privacy Policy.")
                
                Text("Information Collection and Use")
                    .font(.headline)
                
                Text("For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, such as your email address. The information that we collect will be used to contact or identify you.")
                
                Text("Log Data")
                    .font(.headline)
                
                Text("We want to inform you that whenever you visit our Service, we collect information that your browser sends to us that is called Log Data. This Log Data may include information such as your computer's Internet Protocol ('IP') address, browser version, pages of our Service that you visit, the time and date of your visit, the time spent on those pages, and other statistics.")
                
                Text("We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.")
                
                Text("Our Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over, and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.")
                
                Text("Changes to This Privacy Policy")
                    .font(.headline)
                
                Text("We may update our Privacy Policy from time to time. Thus, we advise you to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page.")
                
                Text("If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.")
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PrivacyView()
}
