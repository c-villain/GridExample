//
//  ContentView.swift
//  GridExample
//
//  Created by Alexander Kraev on 19.01.2022.
//

import SwiftUI

struct Constants {
    static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    static let horizontalInset = 16.0
}

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    /**
     For iphone SE we should check if we could show big cell
     because of big cell's width == 343.0.
     By the way you may edit it in BigCell🤷🏼‍♂️
     */
    @State private var shouldShowBigCard = UIScreen.main.bounds.width > 320
    
    @State private var bigCellsIndices: String = ""
    
    let layouts = [
        GridItem.init(.adaptive(minimum: 102.0, maximum: 252.0), spacing: 16.0)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Enter multipliers for big cells indices:")
                    .font(.system(size: 24, weight: .medium, design: .default))
                TextField("", text: $bigCellsIndices)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .textFieldStyle(.roundedBorder)
                Button {
                    withAnimation {
                        viewModel.bigCellIndices = viewModel.parseStringToIntArray(bigCellsIndices)
                    }
                } label: {
                    Text("Generate grid")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(.yellow)
                        .cornerRadius(8)
                }
                Spacer()
            }.padding(30)
            ScrollView {
                LazyVGrid(columns: layouts, alignment: .center, spacing: 40.0) {
                    ForEach(viewModel.items.indices, id: \.self) { num in
                        content(num)
                            .onAppear() {
                                if viewModel.items.indices.contains(num), viewModel.isLast(num) {
                                    viewModel.currentOffset += viewModel.limit
                                }
                            }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .onRotate { _ in
            viewModel.objectWillChange.send()
        }
        .onAppear {
            bigCellsIndices = viewModel.indicesRange
        }
    }
    
    @ViewBuilder
    func content(_ index: Int) -> some View {
        if shouldShowBigCard, viewModel.isBigCellIndex(index + 1) && viewModel.notInLastTwoColumns(index + 1) {
            Group {
                // Insert two clear cells because of width of big cell == 3 cells:
                Color.clear
                BigCell(text: "Big cell \(viewModel.items[index] + 1)")
                Color.clear
            }
        } else {
            Cell(text: "Cell \(viewModel.items[index] + 1)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
