import SwiftUI

struct ConfigTest: View {
    @State private var configStatus = "Testing..."
    @State private var apiKeyPreview = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Config Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Config Status:")
                    .font(.headline)
                Text(configStatus)
                    .foregroundColor(configStatus.contains("✅") ? .green : .red)
                
                Text("API Key Preview:")
                    .font(.headline)
                Text(apiKeyPreview)
                    .font(.monospaced(.caption)())
                    .foregroundColor(.secondary)
                
                Text("Debug Mode:")
                    .font(.headline)
                Text(Config.isDebug ? "✅ Debug" : "🚀 Release")
                
                Text("Location Settings:")
                    .font(.headline)
                Text("Location: \(Config.defaultLocation)")
                    .font(.caption)
                Text("Radius: \(Config.defaultRadius)m")
                    .font(.caption)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button("Test Config Loading") {
                testConfig()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .onAppear {
            testConfig()
        }
    }
    
    private func testConfig() {
        do {
            let key = Config.googlePlacesAPIKey
            
            if key.isEmpty {
                configStatus = "❌ API Key is empty"
                apiKeyPreview = "No key found"
            } else if key.starts(with: "AIzaSy") && key.count > 30 {
                configStatus = "✅ API Key loaded successfully"
                apiKeyPreview = "\(key.prefix(10))...\(key.suffix(4))"
            } else {
                configStatus = "⚠️ API Key format looks wrong"
                apiKeyPreview = "\(key.prefix(10))..."
            }
        } catch {
            configStatus = "❌ Failed to load config: \(error.localizedDescription)"
            apiKeyPreview = "Error loading"
        }
    }
}

#Preview {
    ConfigTest()
} 