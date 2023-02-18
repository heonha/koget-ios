//
//  WidgetList.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/18.
//

import SwiftUI

struct WidgetList: View {
    
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    
    
    var body: some View {
        List(coreData.linkWidgets, id: \.id) { widget in
            
            WidgetIconCell(widget: widget, viewModel: viewModel, type: .list)
                .environmentObject(WidgetCoreData.shared)
            
            
            
            
        }
        .listStyle(.plain)
    }
}


struct WidgetList_Previews: PreviewProvider {
    static var previews: some View {
        WidgetList(viewModel: MainWidgetViewModel.shared)
    }
}
