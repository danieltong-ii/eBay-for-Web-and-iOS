//
//  Toast.swift
//  ebay
//
//  Created by Daniel Tong on 12/3/23.
//
import SwiftUI

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(Color.black)

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 13)
                .opacity(self.isPresented ? 1 : 0)
            } //ZStack (outer)
//            .padding(.bottom)
//            .background(Color(.systemBackground))
        } //GeometryReader
    } //body
} //Toast
