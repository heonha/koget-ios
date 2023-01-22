//
//  ManageWidgetView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/21.
//

import SwiftUI

struct ManageWidgetView: View {
    
    @EnvironmentObject var viewModel: WidgetCoreData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if !viewModel.linkWidgets.isEmpty {
                
                List{
                    
                    ForEach(viewModel.linkWidgets) { widget in
                        LazyHStack {
                            
                            Button {
                                
                            } label: {
                                if let image = widget.image, let name = widget.name {
                                    Image(uiImage: UIImage(data: image)
                                          ?? UIImage(systemName: "questionmark.circle")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    Text(name)
                                }
                            }
                            
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet{
                            print(index)
                            WidgetCoreData.shared.deleteData(data: viewModel.linkWidgets[index])
                        }
                    }
                    
                }
                .listStyle(.plain)
                .toolbar {
                    EditButton()
                }
            } else {
                VStack(spacing: 16) {
                    Text("🥺")
                        .font(.system(size: 50))
                    Text("앗! 편집할 위젯이 없어요")
                    Button {
                        dismiss()
                    } label: {
                        Text("뒤로가기")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    .padding(.vertical, 16)

                }
            }
        }
        
    }
    
}

struct ManageWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ManageWidgetView()
            .environmentObject(StorageProvider())
    }
}
