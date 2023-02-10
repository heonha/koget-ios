// //
// //  UploadLinkView.swift
// //  koget
// //
// //  Created by HeonJin Ha on 2023/01/10.
// //
// 
// import SwiftUI
// 
// struct UploadLinkView: View {
//     
//     
//     @State var name: String = ""
//     @State var nameKr: String = ""
//     @State var nameEn: String = ""
//     @State var url: String = ""
//     @State var imageURL: String = ""
//     
//     @ObservedObject var viewModel = UploadLinkViewModel()
//     @ObservedObject var authModel = AdminAuthModel.shared
//     
//     var body: some View {
//         VStack {
//             
//             if let user = authModel.userSession?.email {
//                 Text("\(user)")
//             } else {
//                 Text("로그인 상태가 아닙니다.")
//             }
// 
//             
//             Image(uiImage: UIImage(named: "youtube") ?? UIImage(systemName: "questionmark.circle")!)
//                 .resizable()
//                 .scaledToFit()
//                 .frame(width: 50, height: 50)
//             CustomTextfield(title: "앱이름", placeholder: "appName", text: $name)
//             CustomTextfield(title: "앱이름(한글)", placeholder: "appNameEn", text: $nameKr)
//             CustomTextfield(title: "앱이름(영문)", placeholder: "appNameEn", text: $nameEn)
//             CustomTextfield(title: "URL", placeholder: "url", text: $url)
//             CustomTextfield(title: "Image URL", placeholder: "imageURL", text: $imageURL)
// 
//             
//             Button {
//                 viewModel.addLinkWidgetAppToFirebase(name: name, nameKr: nameKr, nameEn: nameEn, url: url, imageURL: imageURL)
//                 name = ""
//                 nameKr = ""
//                 nameEn = ""
//                 url = ""
//             } label: {
//                 ZStack {
//                     RoundedRectangle(cornerRadius: 8)
//                         .foregroundColor(.white)
//                     Text("만들기")
//                         .frame(width: 150, height: 40)
//                 }
//                 .frame(width: 150, height: 40)
//                 .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
//             }
//             .padding(16)
//         }
//     }
// }
// 
// struct UploadLinkView_Previews: PreviewProvider {
//     static var previews: some View {
//         UploadLinkView()
//     }
// }
// 
// 
// 
