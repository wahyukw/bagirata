//
//  BreakDownRow.swift
//  Bagirata
//
//  Created by Wahyu K on 3/12/2025.
//

import SwiftUI

struct BreakdownRow: View {
    let label: String
    let amount: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text("$\(String(format:"%.2f", amount))")
                .font(.body)
        }
    }
}
