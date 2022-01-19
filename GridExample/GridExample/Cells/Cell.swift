//
//  Cell.swift
//  GridExample
//
//  Created by Alexander Kraev on 19.01.2022.
//

import SwiftUI

struct Cell: View {
    
    @State var text = ""
    var body: some View {
        Text(text)
            .frame(width: 109, height: 100)
            .background(Color.blue)
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(text: "Cell")
    }
}
