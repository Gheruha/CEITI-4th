//
//  CircleButton.swift
//  lab3
//
//  Created by Gheruha Maxim on 18.02.2026.
//

import Foundation
import SwiftUI

struct CircleButton: View {
    let systemName: String
    var size: CGFloat = 84
    var iconSize: CGFloat = 34
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Image(systemName: systemName)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}
