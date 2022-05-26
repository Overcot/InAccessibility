//
//  StockCell.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockCell: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private let stock: Stock
    private let accessibilityValue: String
    
    init(stock: Stock) {
        self.stock = stock
        self.accessibilityValue = stock.stockPriceFormattedWithDollar + ", " + "change " + stock.changePriceFormattedWithDollar

    }
    var body: some View {
        contentViewDynamicTypeSize
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(stock.name)" + ", " + "\(stock.shortName)")
            .accessibilityRemoveTraits([.isButton])
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Show company info")
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
    }
    
    @ViewBuilder
    private var contentViewDynamicTypeSize: some View {
        if dynamicTypeSize.isAccessibilitySize {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 16) {
                    name
                    StockPrice(stockPrice: stock.stockPriceFormattedWithoutDollar, stockChange: stock.changePriceFormattedWithoutDollar, isGoingUp: stock.goingUp, alignment: .leading)
                }
                Spacer()
                StockGraph(stock: stock)
            }
        } else {
            HStack {
                name
                Spacer()
                StockGraph(stock: stock)
                StockPrice(stockPrice: stock.stockPriceFormattedWithoutDollar, stockChange: stock.changePriceFormattedWithoutDollar, isGoingUp: stock.goingUp, alignment: .trailing)
            }
        }
    }
    
    private var name: some View {
        VStack(alignment: .leading) {
            Text(stock.shortName)
                .font(.body)
                .bold()
            Text(stock.name)
                .font(.caption2)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: .example())
    }
}
