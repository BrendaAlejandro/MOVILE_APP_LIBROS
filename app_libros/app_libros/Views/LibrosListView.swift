//
//  ShoeListView.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import SwiftUI

struct ShoeListView: View {
    @EnvironmentObject var viewModel: ShoesListViewModel // Usar EnvironmentObject
    @State private var selectedTab: String = "Women" // Pestaña seleccionada
    @State private var selectedBottomTab: String = "Shoes" // Pestaña inferior seleccionada
    
    var body: some View {
        VStack {
            if selectedBottomTab == "Shoes" {
                shoesView
            } else if selectedBottomTab == "Favorites" {
                FavoriteListView()
                    .environmentObject(viewModel)
            }
            
            bottomTabBar
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.getShoes(for: selectedTab.uppercased())
        }
    }
    
    private var shoesView: some View {
        VStack {
            headerView
            tabSelectionView
            shoeGridView
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("EazyShoes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Spacer()
        }
        .padding([.top, .leading])
    }
    
    private var tabSelectionView: some View {
        HStack(spacing: 16) {
            ForEach(["Women", "Men", "Kids"], id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    viewModel.getShoes(for: tab.uppercased()) // Carga zapatos según el género
                }) {
                    Text(tab)
                        .font(.headline)
                        .foregroundColor(selectedTab == tab ? .orange : .gray)
                        .padding(.horizontal, 35)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedTab == tab ? Color.orange.opacity(0.2) : Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTab == tab ? Color.orange : Color.gray, lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(.vertical)
    }
    
    private var shoeGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.shoes) { shoe in
                    shoeCardView(shoe: shoe)
                }
            }
            .padding()
        }
    }
    
    private func shoeCardView(shoe: GenderShoes) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: shoe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                        .frame(height: 120)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("$\(shoe.price)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(8)
                    
                    Text(shoe.name)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                    
                    Text(shoe.brand)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            
            Button(action: {
                toggleFavorite(for: shoe)
            }) {
                Image(systemName: shoe.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(shoe.isFavorite ? .orange : .gray)
                    .padding(8)
            }
        }
    }
    
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedBottomTab = "Shoes"
            }) {
                VStack {
                    Image(systemName: "figure.walk")
                        .foregroundColor(selectedBottomTab == "Shoes" ? .orange : .gray)
                    Text("Shoes")
                        .font(.footnote)
                        .foregroundColor(selectedBottomTab == "Shoes" ? .orange : .gray)
                }
            }
            Spacer()
            Spacer()
            Spacer()
            Button(action: {
                selectedBottomTab = "Favorites"
            }) {
                VStack {
                    Image(systemName: "heart")
                        .foregroundColor(selectedBottomTab == "Favorites" ? .orange : .gray)
                    Text("Favorites")
                        .font(.footnote)
                        .foregroundColor(selectedBottomTab == "Favorites" ? .orange : .gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.8))
    }
    
    private func toggleFavorite(for shoe: GenderShoes) {
        viewModel.toggleFavorite(shoe: shoe)
    }
}

#Preview {
    ShoeListView()
}
