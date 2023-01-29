//
//  WidgetGridView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

// 딥링크 위젯 리스트 뷰
struct WidgetGridView: View {
    
    var title: String = ""
    var backgroundColor = AppColors.secondaryBackgroundColor
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    var width = DEVICE_SIZE.width / 4.3
    
    let offColor = Color.init(red: 225/255, green: 225/255, blue: 235/255)
    
    @State var isPresent = false
    @StateObject var coredata = WidgetCoreData.shared
    
    var body: some View {
        
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                
                if !$coredata.linkWidgets.wrappedValue.isEmpty {
                    HStack {
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .padding([.horizontal, .top])
                        Spacer()
                    }
                }
                //MARK: - Grid View
                
                ZStack {
                    
                    //MARK: 위젯이 있을 때.
                    if !$coredata.linkWidgets.wrappedValue.isEmpty {
                        LazyVGrid(columns: gridItem, alignment: .center, spacing: 4) {
                            
                            //MARK: 위젯 Cell
                            ForEach($coredata.linkWidgets.wrappedValue, id: \.id) { widget in
                                WidgetIconCell(widget: widget, cellWidth: width)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 25)
                            .fill(offColor)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 3, y: 3)
                        )
                        .frame(width: DEVICE_SIZE.width - 32)
                        
                    } else {
                        //MARK: 만든 위젯이 0개일 때.

                        Spacer()
                        
                        ZStack {
                            VStack {
                                VStack(spacing: 8) {
                                    
                                    Text("🤔")
                                        .font(.system(size: 50))
                                        .padding(.horizontal, 16)
                                    Text("아직 생성한 위젯이 없어요,")
                                    Text("첫번째 바로가기 위젯을 생성해보세요!")
                                }
                                .padding(.bottom, 32)
                                
                                NavigationLink {
                                    MakeWidgetView()
                                    
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(lineWidth: 2)
                                            .foregroundStyle(Constants.kogetGradient)
                                        
                                        Text("첫번째 바로가기 위젯 만들기")
                                            .font(.system(size: 18, weight: .semibold))
                                            .padding()
                                    }
                                }
                                .frame(width: DEVICE_SIZE.width - 32, height: 40)
                            }
                        }
                        .frame(width: DEVICE_SIZE.width - 32, height: DEVICE_SIZE.height / 1.5)
                        
                        
                        
                        
                    }
                }
                Spacer()
                
            }
        }
    }
    
    
    
}

// 
// struct WidgetGridView_Previews: PreviewProvider {
//     
//     
//     static var previews: some View {
//         
//         NavigationView {
//             WidgetGridView(title: "링크 위젯", widgetCoreData: StorageProvider.preview.persistentContainer)
//             Spacer()
//         }
// 
//     }
// }
