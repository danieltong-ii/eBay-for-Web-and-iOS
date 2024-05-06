//
//  View+Toast.swift
//  ebay
//
//  Created by Daniel Tong on 12/3/23.
//



import Foundation
import SwiftUI

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}
