//
//  ViewModel.swift
//  GridExample
//
//  Created by Alexander Kraev on 19.01.2022.
//

import SwiftUI

@MainActor
final class ViewModel: ObservableObject {
    
    @Published var items: [Int] = .init()
    @Published var isLoading: Bool = false
    @Published var bigCellIndices: [Int] = Constants.isPad ? [7,13] : [3,10]
    
    var indicesRange: String {
        get {
            let stringArray = bigCellIndices.map { String($0) }
            return stringArray.joined(separator: ", ")
        }
    }
    var totalColumns: Int {
        Constants.isPad ? Int((UIScreen.main.bounds.width - Constants.horizontalInset) / (102.0 + 16.0)) : 3
    }
    
    let limit: Int = Constants.isPad ? 45 : 21
    
    init() {
        currentOffset = 0
        Task {
            await fetchData()
        }
    }
    
    var currentOffset: Int {
        didSet {
            Task {
                await fetchData()
            }
        }
    }
    
    private func getItems(limit: Int, offset: Int) async -> [Int] {
        return Array(offset...offset + limit)
    }
    
    func fetchData() async {
        do {
            guard !isLoading else { return }
            isLoading = true
            try await Task.sleep(nanoseconds: 1_500_000_000) // to simulate fetching
            let newInts =  await getItems(limit: limit, offset: currentOffset)
            isLoading = false
            self.items.append(contentsOf: newInts)
        } catch {
            print(error)
        }
    }
    
    // approximite big cell index
    func isBigCellIndex(_ index: Int) -> Bool {
        for i in 0..<bigCellIndices.count {
            if index.isMultiple(of: bigCellIndices[i]) {
                return true
            }
        }
        return false
    }
    
    /**
     check if cursor not in last two columns because
     width of big cell = 3 * default cell's width
     */
    func notInLastTwoColumns(_ index: Int) -> Bool {
        let cursor = getGridCursorForNext(index)
        return !cursor.isMultiple(of: totalColumns) && (cursor % totalColumns != totalColumns - 1)
    }
    
    /**
     Get cursor for next item in grid
     */
    private func getGridCursorForNext(_ index: Int) -> Int {
        var cursor: Int = 0
        
        for index in 0..<index {
            if isBigCellIndex(index)
                // not in last two columns because big cell == 3 * cell :
                , cursor % totalColumns != totalColumns - 1
                , !cursor.isMultiple(of: totalColumns) { ///  faster than: cursor % totalColumns != 0
                cursor += 3
            } else { cursor += 1 }
        }
        
        return cursor
    }
    
    func isLast(_ index: Int) -> Bool {
        return items.count - index == 1
    }
    
    func parseStringToIntArray(_ string: String) -> [Int] {
        let separators = CharacterSet(charactersIn: ",; ")
        let stringArray = string.components(separatedBy: separators)
        return stringArray.compactMap { Int($0) }
    }
    
}
