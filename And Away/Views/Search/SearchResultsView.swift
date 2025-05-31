import SwiftUI

struct SearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Header showing what we're searching for
            HStack {
                Text("Results for \"\(searchText)\"")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            
            // Placeholder results for now
            VStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 32, height: 32)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Search result \(index + 1)")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text("This matches your search for \"\(searchText)\"")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    
                    if index < 4 {
                        Divider()
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    SearchResultsView(searchText: "test search")
} 