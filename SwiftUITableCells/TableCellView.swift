//
//  TableCellView.swift
//  SwiftUITableCells
//
//  Created by Alexander Jährling on 12.05.22.
//

import SwiftUI

class CellData: ObservableObject {
    @Published var text: String = ""
    @Published var subtitle: String = ""
    @Published var label: String = "label"
    
    init() {}
}

struct TableCellView: View {
    #if UseMyHostingCell
    @ObservedObject var hostingCell: HostingCell
    #else
    @ObservedObject var hostingCell: CellData
    #endif

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 1000), spacing: 4, alignment: .trailing),
        GridItem(.adaptive(minimum: 100, maximum: 1000), spacing: 4, alignment: .trailing),
        GridItem(.flexible(minimum: 100, maximum: 1000), spacing: 4, alignment: .trailing),
        GridItem(.flexible(minimum: 100, maximum: 1000), spacing: 4, alignment: .trailing)
    ]
    
    var data = (0..<8).map { "\($0*$0*$0*$0*$0*$0)"}

    var body: some View {
        #if false   // this simple case already causes the empty space issue
        Text(hostingCell.text).frame(width: 400, height: 200, alignment: .center).background(Color.yellow)
            .fixedSize(horizontal: false, vertical: true)
        #else
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                Text(hostingCell.text).fixedSize()//.lineLimit(3).background(Color.green)
            }
            Text(hostingCell.subtitle).font(.caption).foregroundColor(.gray)
            Text(hostingCell.label).font(.largeTitle).frame(maxWidth: .infinity, alignment: .trailing)
            ScrollView(.horizontal) {
                LazyVGrid(columns: columns) {
                    ForEach(data, id: \.self) {
                        Text($0)
                    }
                }.frame(minWidth: 800)
            }
        }
        .background(Color.yellow)
        .padding()
        .background(Color.blue)
        .fixedSize(horizontal: false, vertical: true)
        #endif
    }
}

//struct TableCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        TableCellView(text: .constant("Hello"), subtitle: .constant("World!"), label: .constant("Blub"))
//    }
//}
