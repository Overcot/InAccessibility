//
//  ContentView.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

struct MainView: View {
    private let favoriteStocks: [Stock]
    private let allStocks: [Stock]
    
    init(favoriteStocks: [Stock], allStocks: [Stock]) {
        self.favoriteStocks = favoriteStocks
        self.allStocks = allStocks
    }
    
    @State private var showDetailStock: Stock?
    @State private var showInfoStock: Stock? = nil
    @State private var showFavoriteStock: Stock? = nil
    @State private var textSearch: String = ""
    
    private var searchFavoriteStocksResults: [Stock] {
        if textSearch.isEmpty {
            return favoriteStocks
        } else {
            return favoriteStocks.filter {
                $0.shortName.contains(textSearch) || $0.name.contains(textSearch)
            }
        }
    }
    
    private var searchAllStocksResults: [Stock] {
        if textSearch.isEmpty {
            return allStocks
        } else {
            return allStocks.filter {
                $0.shortName.contains(textSearch) || $0.name.contains(textSearch)
            }
        }
    }
        
    var body: some View {
        NavigationView {
            List {
                favoriteStocksSection
                allStocksSection
            }
            .navigationViewStyle(.columns)
            .alert(showInfoStock?.name ?? "", isPresented: .init(get: {
                showInfoStock != nil
            }, set: { newValue in
                if (!newValue) {
                    showInfoStock = nil
                }
            }), presenting: showInfoStock, actions: { _ in
                Button("OK") {
                    showInfoStock = nil
                }.keyboardShortcut(.defaultAction)
                
            }, message: { stock in
                Text("The stock price for \(stock.name) (\(stock.shortName)) is \(stock.stockPriceFormattedWithDollar).")
            })
            .alert(showFavoriteStock?.name ?? "", isPresented: .init(get: {
                showFavoriteStock != nil
            }, set: { newValue in
                if (!newValue) {
                    showFavoriteStock = nil
                }
            }), presenting: showFavoriteStock, actions: { _ in
                Button("OK") {
                    showFavoriteStock = nil
                }.keyboardShortcut(.defaultAction)
            }, message: { stock in
                if stock.favorite {
                    Text("The \(stock.name) was removed from favorites")
                } else {
                    Text("The \(stock.name) was added to favorites")
                }
            })
            .navigationTitle("Stocks")
            .toolbar(content: {
                toolbarItems
            }).searchable(text: $textSearch) {
                ForEach(searchAllStocksResults, id: \.self) { stock in
                    Text("\(stock.shortName) - \(stock.name)").searchCompletion(stock.name)
                }
            }
        }
    }
    
    var favoriteStocksSection: some View {
        Section {
            ForEach(searchFavoriteStocksResults) { stock in
                cellView(stock: stock)
            }
        } header: {
            Text("Favorite Stocks")
                .accessibilityHeading(.h2)
        } footer: {
            Text("Favorite stocks are updated every 1 minute.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
    }
    
    var allStocksSection: some View {
        Section {
            ForEach(searchAllStocksResults) { stock in
                cellView(stock: stock)
            }
        } header: {
            Text("All Stocks")
                .accessibilityHeading(.h2)
        }
    }
    
    var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                
            } label: {
                Label("Settings", systemImage: "gearshape.fill")
                    .labelStyle(.titleOnly)
            }.accessibilityShowsLargeContentViewer {
                Text("Settings")
            }
        }
    }
    private func cellView(stock: Stock) -> some View {
        NavigationLink(
            tag: stock,
            selection: $showDetailStock,
            destination: {
                DetailView(stock: stock)
            }
        ) {
            StockCell(stock: stock)
        }
        .swipeActions(edge: .leading, content: {
            favoriteOrUnfavoriteButton(stock: stock)
        })
        .swipeActions(content: {
            infoButton(stock: stock)
        })
        .contextMenu {
            VStack {
                infoButton(stock: stock)
                Divider()
                favoriteOrUnfavoriteButton(stock: stock)
            }
        }
        .contentShape(Rectangle())
        .accessibilityAction {
            showDetailStock = stock
        }
    }
    
    private func infoButton(stock: Stock) -> some View {
        Button {
            showInfoStock = stock
        } label: {
            Label("Show stock info", systemImage: "info.circle.fill")
        }
        .tint(Color(uiColor: .systemBlue))
    }
    
    private func favoriteOrUnfavoriteButton(stock: Stock) -> some View {
        Button {
            showFavoriteStock = stock
        } label: {
            if stock.favorite {
                Label("Remove from favorites", systemImage: "star.slash")
            } else {
                Label("Mark as favorite", systemImage: "star")
            }
        }
        .tint(Color(uiColor: .systemYellow))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(favoriteStocks: Stock.favorites(), allStocks: Stock.all())
    }
}
