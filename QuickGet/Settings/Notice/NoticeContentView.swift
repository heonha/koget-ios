//
//  NoticeContentView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/12/01.
//

import SwiftUI

struct NoticeContentView: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TextField("", text: .constant(" 앱이 출시되었습니다."))
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: 40)
                .cornerRadius(10)
                .padding()
            TextField("", text: .constant(" 앱이 출시되었습니다."))
                .font(.system(size: 16))
                .frame(width: DEVICE_SIZE.width - 32, height: DEVICE_SIZE.height - 80)
                .cornerRadius(10)
                .padding()
            Spacer()
        }
        .padding()
    }
}

struct NoticeContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeContentView()
    }
}
