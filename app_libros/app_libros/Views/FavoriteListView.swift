//
//  FavoriteListView.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var viewModel: ShoesListViewModel
    
    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                gradient: Gradient(colors: [Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                    .padding(.leading, 16)
                    .padding(.top, 20)
                
                if viewModel.favorites.isEmpty {
                    Spacer()
                    Text("No favorites yet!")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.favorites) { shoe in
                            HStack {
                                // Imagen y detalles del zapato
                                AsyncImage(url: URL(string: shoe.image)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
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
                                        .foregroundColor(.white)
                                    Text("Women")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.black)
                            .cornerRadius(12)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(shoe: shoe)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
    }
}


// Preview
#Preview {
    FavoriteListView()
        .environmentObject(ShoesListViewModel())
}
