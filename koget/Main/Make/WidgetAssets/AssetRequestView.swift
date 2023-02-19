//
//  AssetRequestView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/19.
//

import SwiftUI

struct AssetRequestView: View {
    
    @State var appName: String = ""
    @State var bodyText: String = ""

    
    var body: some View {

            VStack {

                Group {
                    VStack {
                        Text("앱 추가 요청")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Divider()
                    }
                }
                .padding(.vertical, 16)

                

                //MARK: 앱 이름
                HStack {
                    Spacer()
                    Text("앱 이름")
                        .bold()
                        .frame(width: 100)
                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(uiColor: .secondarySystemFill))
                            .opacity(0.8)
                        TextField("앱 이름", text: $appName)
                            .padding(.horizontal, 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 4)

                }
                .frame(height: 50)
                
                //MARK: 앱 이름
                HStack {
                    Spacer()

                    Text("내용")
                        .bold()
                        .frame(width: 100)
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(uiColor: .secondarySystemFill))
                            .opacity(0.8)
                        TextField("선택사항", text: $bodyText)
                            .padding(.horizontal, 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 4)
                    
                }
                .frame(height: 50)

                Spacer()

                Text("요청하신 앱은 검토 결과에 따라 앱에 추가 될 예정입니다.")
                    .font(.system(size: 13))
                    .padding()
                             
                
                Button("요청하기"){
                    
                }
                .backgroundStyle(.gray)
                .padding(.vertical, 4)
                
                
                
            }
            .padding(.vertical)

            .presentationDetents([.height(DEVICE_SIZE.height / 3)])

    }
}

struct AssetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AssetRequestView()
    }
}
