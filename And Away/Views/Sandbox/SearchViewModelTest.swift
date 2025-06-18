import SwiftUI

struct SearchViewModelTest: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = "coffee"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SearchViewModel Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Search input
            VStack(alignment: .leading) {
                Text("Search Query:")
                    .font(.headline)
                
                HStack {
                    TextField("Enter search term", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Search") {
                        Task {
                            await viewModel.searchImmediately(query: searchText)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            // ViewModel state display
            VStack(alignment: .leading, spacing: 10) {
                Text("ViewModel State:")
                    .font(.headline)
                
                HStack {
                    Text("Loading:")
                    Text(viewModel.isLoading ? "✅ Yes" : "❌ No")
                        .foregroundColor(viewModel.isLoading ? .green : .secondary)
                }
                
                HStack {
                    Text("Has Results:")
                    Text(viewModel.hasResults ? "✅ Yes (\(viewModel.searchResults.count))" : "❌ No")
                        .foregroundColor(viewModel.hasResults ? .green : .secondary)
                }
                
                HStack {
                    Text("Has Searched:")
                    Text(viewModel.hasSearched ? "✅ Yes" : "❌ No")
                        .foregroundColor(viewModel.hasSearched ? .green : .secondary)
                }
                
                if let error = viewModel.errorMessage {
                    VStack(alignment: .leading) {
                        Text("Error:")
                            .foregroundColor(.red)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Search state display
            VStack(alignment: .leading) {
                Text("Search State:")
                    .font(.headline)
                
                switch viewModel.searchState {
                case .empty:
                    Text("📭 Empty")
                case .loading:
                    Text("⏳ Loading...")
                case .results(let places):
                    Text("📍 Results (\(places.count))")
                case .noResults:
                    Text("🔍 No Results")
                case .error(let message):
                    Text("❌ Error: \(message)")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            // Results display (first 3)
            if viewModel.hasResults {
                VStack(alignment: .leading) {
                    Text("Sample Results:")
                        .font(.headline)
                    
                    ForEach(Array(viewModel.searchResults.prefix(3)), id: \.placeId) { place in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            if let vicinity = place.vicinity {
                                Text(vicinity)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("Types: \(place.types.prefix(3).joined(separator: ", "))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        Divider()
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: searchText) { _, newValue in
            Task {
                await viewModel.search(query: newValue)
            }
        }
        .onAppear {
            Task {
                await viewModel.search(query: searchText)
            }
        }
    }
}

#Preview {
    SearchViewModelTest()
} 