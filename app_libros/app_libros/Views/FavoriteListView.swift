import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var viewModel: LibrosListViewModel
    
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
                Text("Favoritos")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                    .padding(.leading, 16)
                    .padding(.top, 20)
                
                if viewModel.favorites.isEmpty {
                    Spacer()
                    Text("¡Aún no tienes favoritos!")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.favorites) { libro in
                            HStack {
                                // Imagen y detalles del libro
                                AsyncImage(url: URL(string: libro.imageUrl)) { image in
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
                                    Text(libro.title)
                                        .font(.headline)
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
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.black)
                            .cornerRadius(12)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(libro: libro)
                                } label: {
                                    Label("Eliminar", systemImage: "trash.fill")
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
        .environmentObject(LibrosListViewModel())
}
