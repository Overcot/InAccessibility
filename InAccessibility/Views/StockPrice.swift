//
//  StockPrice.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockPrice: View {
    internal init(stockPrice: String, stockChange: String, isGoingUp: Bool, alignment: HorizontalAlignment) {
        self.stockPrice = stockPrice
        self.stockChange = stockChange
        self.isGoingUp = isGoingUp
        self.alignment = alignment
    }
    
    let stockPrice: String
    let stockChange: String
    let isGoingUp: Bool
    let alignment: HorizontalAlignment
    var body: some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(stockPrice)
                .foregroundColor(.primary)
            Text(stockChange)
                .bold()
                .font(.caption)
                .padding(4)
                .background(isGoingUp ? Color(uiColor: .systemGreen) : Color(uiColor: .systemRed))
                .cornerRadius(6)
                .foregroundColor(.white)

        }
    }
}

struct CellHorizontalAlignment: AlignmentID {
  static func defaultValue(in context: ViewDimensions) -> CGFloat {
    context[HorizontalAlignment.leading]
  }
}

extension HorizontalAlignment {
  static let cellHorizontalAlignment: HorizontalAlignment = .init(CellHorizontalAlignment.self)
}

struct StockPrice_Previews: PreviewProvider {
    static var previews: some View {
        StockPrice(stockPrice: "123.54", stockChange: "123.53", isGoingUp: true, alignment: .leading)
    }
}
