//
//  WidgetLinkTypeIcon.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/15.
//

import SwiftUI

struct WidgetLinkTypeIcon: View {
    
    @StateObject var viewModel: MainWidgetViewModel
    var url: String
    
    var body: some View {
        
            switch viewModel.checkLinkType(url: url) {
            case .app:
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 13, height: 13)
                            Image(systemName: "arrow.up.left.square.fill")
                                .foregroundStyle(Constants.kogetGradient)
                                .font(.system(size: 18, weight: .semibold))
                                .clipShape(Circle())
                                .shadow(radius: 0.3, x: 0.5, y: 0.5)
                        }
                    }
                }
                .padding([.bottom, .trailing], -4)
            case .web:
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 13, height: 13)
                            Image(systemName: "network")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.blue)
                                .clipShape(Circle())
                                .shadow(radius: 0.3, x: 0.5, y: 0.5)
                        }
                    }
                }
                .padding([.bottom, .trailing], -4)
            }
    }
}

struct WidgetLinkTypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        WidgetLinkTypeIcon(viewModel: MainWidgetViewModel.shared, url: "url")
    }
}
