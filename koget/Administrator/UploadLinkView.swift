//
//  UploadLinkView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/10.
//

import SwiftUI

struct UploadLinkView: View {
    
    
    @State var appName: String = ""
    @State var appNameEn: String = ""
    @State var url: String = ""
    @State var image: UIImage?
    @State var isPresent: Bool = false
    
    
    
    var body: some View {
        VStack {
            CustomTextfield(title: "앱이름", placeholder: "appName", text: $appName)
            CustomTextfield(title: "앱이름(영문)", placeholder: "appNameEn", text: $appNameEn)
            CustomTextfield(title: "URL", placeholder: "url", text: $url)
            Button {
                isPresent.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 150))
            }
            .sheet(isPresented: $isPresent) {
                PhotoPicker()
            }

            
        }
    }
}

struct UploadLinkView_Previews: PreviewProvider {
    static var previews: some View {
        UploadLinkView()
    }
}
