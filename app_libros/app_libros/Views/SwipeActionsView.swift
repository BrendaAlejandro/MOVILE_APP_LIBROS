//
//  SwipeActionsView.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import Foundation

import SwiftUI

struct SwipeActionsView<Content: View>: View {
    var libro: Libros
    var content: () -> Content
    @EnvironmentObject var viewModel: LibrosListViewModel
    var body: some View {
    ZStack {
            HStack {
                Spacer()
                Button(action: {

                    viewModel.removeFavorite(libro: libro)

                }) {

                    Image(systemName: "trash.fill")

                        .foregroundColor(.white)

                        .frame(width: 60, height: 80)

                        .background(Color.red)

                        .cornerRadius(12)

                }

            }



            content()

        }

        .swipeActions(edge: .trailing, allowsFullSwipe: true) {

            Button(role: .destructive) {

                viewModel.removeFavorite(libro: libro)

            } label: {

                Label("Delete", systemImage: "trash.fill")

            }

        }

    }

}


