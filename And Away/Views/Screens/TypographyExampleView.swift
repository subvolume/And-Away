//
//  TypographyExampleView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct TypographyExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Page title")
                    .pageTitle()
                
                Text("Page subtitle")
                    .pageSubtitle()
                
                Text("Page note")
                    .pageNote()
                
                Text("Button small")
                    .button()
                
                Text("List title")
                    .listTitle()
                
                Text("List subtitle")
                    .listSubtitle()
                
                Text("Notes")
                    .listNote()
                
                Text("Card title")
                    .cardTitle()
                
                Text("Card subtitle")
                    .cardSubtitle()
                
                Text("Today title")
                    .listTitle()
                
                Text("Today subtitle")
                    .listSubtitle()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, Spacing.m)
            .padding(.vertical, 8)
        }
        .navigationTitle("Typography")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview
struct TypographyExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TypographyExampleView()
        }
    }
} 
