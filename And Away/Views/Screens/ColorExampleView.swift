//
//  ColorExampleView.swift
//  And Away
//
//  Created by Oliver Lukman on 29/05/2025.
//

import SwiftUI

struct ColorExampleView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ListItem(color: .primary, title: ".primary", subtitle: "Main content color", thirdText: nil)
                ListItem(color: .secondary, title: ".secondary", subtitle: "Supporting text", thirdText: nil)
                ListItem(color: .tertiary, title: ".tertiary", subtitle: "Subtle text", thirdText: nil)
                ListItem(color: .invert, title: ".invert", subtitle: "Opposite content", thirdText: nil)
                
                ListItem(color: .backgroundPrimary, title: ".backgroundPrimary", subtitle: "Main background", thirdText: nil)
                ListItem(color: .backgroundSecondary, title: ".backgroundSecondary", subtitle: "Supporting areas", thirdText: nil)
                ListItem(color: .backgroundTertiary, title: ".backgroundTertiary", subtitle: "Subtle areas", thirdText: nil)
                ListItem(color: .backgroundInvert, title: ".backgroundInvert", subtitle: "Opposite background", thirdText: nil)
                ListItem(color: .backgroundSelected, title: ".backgroundSelected", subtitle: "Selection state", thirdText: nil)
                
                ListItem(color: .black100, title: ".black100", subtitle: "#1A1C1E", thirdText: nil)
                ListItem(color: .grey100, title: ".grey100", subtitle: "#77818C", thirdText: nil)
                ListItem(color: .smoke100, title: ".smoke100", subtitle: "#A5ACB6", thirdText: nil)
                ListItem(color: .white100, title: ".white100", subtitle: "#FFFFFF", thirdText: nil)
                
                ListItem(color: .azure100, title: ".azure100", subtitle: "#128DFF", thirdText: nil)
                ListItem(color: .blue100, title: ".blue100", subtitle: "#003CFF", thirdText: nil)
                ListItem(color: .sky100, title: ".sky100", subtitle: "#00DDFF", thirdText: nil)
                ListItem(color: .aqua100, title: ".aqua100", subtitle: "#10E7E6", thirdText: nil)
                ListItem(color: .teal100, title: ".teal100", subtitle: "#05C8BA", thirdText: nil)
                
                ListItem(color: .green100, title: ".green100", subtitle: "#3BCF61", thirdText: nil)
                ListItem(color: .yellow100, title: ".yellow100", subtitle: "#FFE700", thirdText: nil)
                ListItem(color: .orange100, title: ".orange100", subtitle: "#FF8800", thirdText: nil)
                ListItem(color: .red100, title: ".red100", subtitle: "#FF4274", thirdText: nil)
                
                ListItem(color: .purple100, title: ".purple100", subtitle: "#9355FF", thirdText: nil)
                ListItem(color: .lilac100, title: ".lilac100", subtitle: "#C756FF", thirdText: nil)
                ListItem(color: .lavender100, title: ".lavender100", subtitle: "#8287AF", thirdText: nil)
            }
        }
        .navigationTitle("Colors")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview
struct ColorExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorExampleView()
        }
    }
} 
