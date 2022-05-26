//
//  DetailView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

enum AlertItem: String, Identifiable {
    case share
    case favorite
    
    var id: String { self.rawValue }
}
struct DetailView: View {
    internal init(stock: Stock) {
        self.stock = stock
        var visualDescription = "This is a company that was founded at some point in time by some people with some ideas. The company makes products and they do other things as well. Some of these things go well, some don't. The company employs people, somewhere between 10 and 250.000. The exact amount is not currently available."
        var accessibleDescription = visualDescription
        
        let firstNumberValue = NSNumber(value: 10)
        let firstNumberLocalized = NumberFormatter.localizedString(from: firstNumberValue,
                                                  number: .decimal)
        let firstNumberAccessible = NumberFormatter.localizedString(from: firstNumberValue,
                                                         number: .spellOut)
        
        let secondNumberValue = NSNumber(value: 250000)
        let secondNumberLocalized = NumberFormatter.localizedString(from: secondNumberValue,
                                                  number: .decimal)
        let secondNumberAccessible = NumberFormatter.localizedString(from: secondNumberValue,
                                                         number: .spellOut)
        
        visualDescription = visualDescription.replacingOccurrences(of: "10", with: firstNumberLocalized).replacingOccurrences(of: "250.000", with: secondNumberLocalized)
        
        accessibleDescription = accessibleDescription.replacingOccurrences(of: "10", with: firstNumberAccessible).replacingOccurrences(of: "250.000", with: secondNumberAccessible)
        self.visualDescription = visualDescription
        self.accessibleDescription = accessibleDescription
    }
    
    
    private let stock: Stock
    private let visualDescription: String
    private let accessibleDescription: String
    @State private var selectedAlertItem: AlertItem?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityShowButtonShapes) private var accessibilityShowButtonShapes

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                companyInfo
                    .accessibilityHeading(.h1)
                description
                buttons
            }
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    selectedAlertItem = .favorite
                } label: {
                    Image(systemName: "star")
                }
                .accessibilityShowsLargeContentViewer {
                    Text("Favorite")
                }
                Button {
                    selectedAlertItem = .share

                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityShowsLargeContentViewer {
                    Text("Share")
                }
            }
        })
        .scenePadding()
        .navigationTitle(stock.shortName)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $selectedAlertItem, content: { item in
            Alert(title: Text(dialogTitle))
        })
    }
    private var dialogTitle: LocalizedStringKey {
        switch selectedAlertItem {
        case .share:
            return "Thanks for sharing!"
        case .favorite:
            return "Thanks for favoriting (but not really)!"
        case .none:
            return ""
        }
    }
    
    var companyInfo: some View {
        HStack {
            Text(stock.name)
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
            Spacer()
            StockGraph(stock: stock)
        }
    }
    
    private var description: some View {
        VStack(alignment: .leading) {
            Text("Company Description")
                .font(.title2.weight(.semibold))
                .accessibilityHeading(.h2)

            Text(visualDescription)
                .accessibilityLabel(accessibleDescription)
                .accessibilityTextContentType(.narrative)
                .font(.body)
        }
    }
    
    @ViewBuilder
    var buttons: some View {
        if horizontalSizeClass == .regular {
            HStack {
                buttonsContent
            }
        } else {
            VStack {
                buttonsContent
            }
        }
    }
    var buttonsContent: some View {
        Group {
            Button {
                selectedAlertItem = .share
            } label: {
                Text("Share")
                    .underline(accessibilityShowButtonShapes, color: .white)
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .tint(Color(uiColor: .systemBlue))
            Button {
                selectedAlertItem = .favorite
            } label: {
                Text("Favorite")
                    .underline(accessibilityShowButtonShapes, color: .white)
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .tint(Color(uiColor: .systemYellow))
        }
        .font(.title2.bold())
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 16))
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(stock: .example())
    }
}
