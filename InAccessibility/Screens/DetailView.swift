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
    
    let stock: Stock
    @State var selectedAlertItem: AlertItem?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            companyInfo
            description
            buttons
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
            if item == .share {
                return Alert(title: Text("Thanks for sharing!"))
            } else {
                return Alert(title: Text("Thanks for favoriting (but not really)!"))
            }
        })
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
    
    var description: some View {
        VStack(alignment: .leading) {
            Text("Company Description")
                .font(.title2.weight(.semibold))
            Text("This is a company that was founded at some point in time by some people with some ideas. The company makes products and they do other things as well. Some of these things go well, some don't. The company employs people, somewhere between 10 and 250.000. The exact amount is not currently available.")
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
                Text("Tap to share")
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .tint(.blue)
            Button {
                selectedAlertItem = .favorite
            } label: {
                Text("Favorite")
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .tint(.yellow)
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
