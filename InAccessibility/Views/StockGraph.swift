//
//  StockGraph.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct StockGraph: View {
    let stock: Stock
    
    let points: [Int] = [10, 20, 30, 40, 30, 25, 44]
    
    @State private var bigCircles = false
    @State private var showDots = false
    @Environment(\.accessibilityReduceTransparency) private var accessibilityReduceTransparency
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    @Environment(\.legibilityWeight) private var legibilityWeight
    @Namespace private var circles
    internal init(stock: Stock) {
        self.stock = stock
    }
    
    
    var body: some View {
        HStack(spacing: bigCircles ? 2 : 8) {
            ForEach(0..<points.count, id:\.self) { index in
                Circle()
                    .frame(width: bigCircles ? 10 : 4, height: bigCircles ? 10 : 4)
                    .foregroundColor(stock.goingUp ? Color(uiColor: .systemGreen): Color(uiColor: .systemRed))
                    .offset(y: CGFloat(stock.goingUp ? -points[index] : points[index]) * 0.3)
            }
        }
        .opacity(accessibilityReduceTransparency ? 1 : (showDots ? 1 : 0))
        .offset(y: showDots ? 0 : 12)
        .animation(accessibilityReduceMotion ? nil : .default, value: showDots)
        .frame(width: 100, height: 50)
        .background {
            Color(uiColor: UIColor.tertiarySystemGroupedBackground)
                .cornerRadius(7)
        }.onTapGesture(perform: {
            withAnimation(accessibilityReduceMotion ? nil : .spring()) {
                bigCircles.toggle()
            }
        })
        .onChange(of: legibilityWeight, perform: { newValue in
            if newValue == .bold {
                bigCircles = true
            }
        })
        .onAppear {
            showDots = true
            if legibilityWeight == .bold {
                bigCircles = true
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Chart representing change in stock price")
        .accessibilityChartDescriptor(MyChartDescriptorRepresentable(stock: stock, stockChange: points))

    }
}
struct MyChartDescriptorRepresentable: AXChartDescriptorRepresentable {
    private let stock: Stock
    private let stockChange: [Int]
    private let daysOfWeek: [String]
    init(stock: Stock, stockChange: [Int]) {
        self.stock = stock
        self.stockChange = stockChange
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        self.daysOfWeek = (-6...0).map { i in
            return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: Date())!)
        }
    }
    
    func makeChartDescriptor() -> AXChartDescriptor {
        let dataPoints = zip(daysOfWeek, stockChange).map { (weekDay: String, value: Int) in
            return AXDataPoint(x: weekDay, y: Double(value))
        }
        let min = stockChange.map { Double($0) }.min() ?? 0.0
        let max = stockChange.map { Double($0) }.max() ?? 0.0

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Change in stock price",
            range: stock.goingUp ? min...max : (-max)...(-min), gridlinePositions: [], valueDescriptionProvider: {
            String($0)
        })
        return AXChartDescriptor(
            title: "\(stock.shortName)",
            summary: "Changes of \(stock.shortName)",
            xAxis: AXCategoricalDataAxisDescriptor(title: "Days of week", categoryOrder: daysOfWeek),
            yAxis: yAxis,
            additionalAxes: [],
            series: [.init(name: "Change", isContinuous: true, dataPoints: dataPoints)]
        )
        
    }
    func updateChartDescriptor(_ descriptor: AXChartDescriptor) {
        
    }
   }
struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph(stock: .example())
        StockGraph(stock: .example())
    }
}
