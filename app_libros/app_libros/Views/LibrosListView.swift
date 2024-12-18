import SwiftUI

struct LibrosListView: View {
    @EnvironmentObject var viewModel: LibrosListViewModel // Usar EnvironmentObject
    @State private var selectedTab: String = "Romance" // Pestaña seleccionada
    @State private var selectedBottomTab: String = "Libros" // Pestaña inferior seleccionada
    
    var body: some View {
        VStack {
            if selectedBottomTab == "Libros" {
                librosView
            } else if selectedBottomTab == "Favorites" {
                FavoriteListView()
                    .environmentObject(viewModel)
            }
            
            bottomTabBar
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.getLibros(for: selectedTab)
        }
    }
    
    private var librosView: some View {
        VStack {
            headerView
            tabSelectionView
            libroGridView
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Biblioteca")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Spacer()
        }
        .padding([.top, .leading])
    }
    
    private var tabSelectionView: some View {
        HStack(spacing: 16) {
            ForEach(["Romance", "Ficción", "Misterio"], id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    viewModel.getLibros(for: tab) // Carga libros según el género
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
    
    private var libroGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.libros) { libro in
                    libroCardView(libro: libro)
                }
            }
            .padding()
        }
    }
    
    private func libroCardView(libro: Libros) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: libro.imageUrl)) { image in
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
                    Text(libro.title)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                    
                    Text(libro.autor)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(libro.ano, specifier: "%.0f")")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 8)
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            
            Button(action: {
                toggleFavorite(for: libro)
            }) {
                Image(systemName: libro.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(libro.isFavorite ? .orange : .gray)
                    .padding(8)
            }
        }
    }
    
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedBottomTab = "Libros"
            }) {
                VStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(selectedBottomTab == "Libros" ? .orange : .gray)
                    Text("Libros")
                        .font(.footnote)
                        .foregroundColor(selectedBottomTab == "Libros" ? .orange : .gray)
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
                    Text("Favoritos")
                        .font(.footnote)
                        .foregroundColor(selectedBottomTab == "Favorites" ? .orange : .gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.8))
    }
    
    private func toggleFavorite(for libro: Libros) {
        viewModel.toggleFavorite(libro: libro)
    }
}

#Preview {
    LibrosListView()
}
