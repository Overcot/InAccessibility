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
                }
                
            }, message: { stock in
                Text("The stock price for \(stock.name) (\(stock.shortName)) is \(stock.stockPriceFormattedWithDollar).")
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
                    Button {
                        
                    } label: {
                        if stock.favorite {
                            Label("UnFavorite", systemImage: "star.slash")
                        } else {
                            Label("Favorite", systemImage: "star.slash")
                        }
                    }
                    .tint(.yellow)
                })
                .swipeActions(content: {
                    Button {
                        showInfoStock = stock
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(.accentColor)
                })
                .contextMenu {
                    Button {
                        showInfoStock = stock
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(.accentColor)
                }
                
                .contentShape(Rectangle())
                .onTapGesture {
                    showDetailStock = stock
                }
                .accessibilityAction {
                    showDetailStock = stock
                }
            }
        } header: {
            HStack {
                Text("Favorite Stocks")
                Spacer()
                Button {
                    
                } label: {
                    Text("Tap for more")
                }
                
            }
        } footer: {
            Text("Favorite stocks are updated every 1 minute.")
        }
        
    }
    
    var allStocksSection: some View {
        Section {
            ForEach(searchAllStocksResults) { stock in
                StockCell(stock: stock)
                    .swipeActions(content: {
                        Button {
                            showInfoStock = stock
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                        .tint(.accentColor)
                    })
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showDetailStock = stock
                    }
                    .accessibilityAction {
                        showDetailStock = stock
                    }
            }
        } header: {
            Text("All Stocks")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(favoriteStocks: Stock.favorites(), allStocks: Stock.all())
    }
}
