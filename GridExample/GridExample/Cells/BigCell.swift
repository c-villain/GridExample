//
//  BigCell.swift
//  GridExample
//
//  Created by Alexander Kraev on 19.01.2022.
//

import SwiftUI

struct BigCell: View {
    
    @State var text = ""
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .frame(width: 343, height: 100)
            .background(Color.yellow)
    }
}

struct BigCell_Previews: PreviewProvider {
    static var previews: some View {
        BigCell(text: "Big Cell")
    }
}
