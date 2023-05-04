//
//  WidgetGridLinkTypeIcon.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/15.
//

import SwiftUI
import SFSafeSymbols

struct WidgetGridLinkTypeIcon: View {
    
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
                                .foregroundStyle(AppColor.Background.first)
                                .frame(width: 13, height: 13)
                            Image(systemSymbol: .arrowUpLeftCircleFill)
                                .foregroundStyle(AppColor.kogetRed)
                                .font(.system(size: 18, weight: .semibold))
                                .shadow(color: .black.opacity(0.2) ,radius: 0.3, x: 0.5, y: 0.5)
                                .opacity(0.8)
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
                                .foregroundStyle(AppColor.Background.first)
                                .frame(width: 13, height: 13)
                            Image(systemSymbol: .network)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.blue)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2) ,radius: 0.3, x: 0.5, y: 0.5)
                        }
                    }
                }
                .padding([.bottom, .trailing], -4)
                .opacity(0.8)
            }
    }
}

struct WidgetLinkTypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WidgetGridCell(name: "위젯이름", url: "https://google.com", widgetImage: UIImage.init(named: "tmap")!, cellWidth: widgetCellWidthForGrid, viewModel: MainWidgetViewModel())
            WidgetGridCell(name: "위젯이름", url: "fdsf://google.com", widgetImage: UIImage.init(named: "tmap")!, cellWidth: widgetCellWidthForGrid, viewModel: MainWidgetViewModel())
        }
 
    }
}
