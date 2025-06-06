import SwiftUI
import MapKit

struct SandboxView: View {
    @State private var showSheetA = true
    @State private var showSheetB = false
    @State private var sheetBHasReachedMedium = false
    
    @State private var sheetADetent: SheetDetent = .medium
    @State private var sheetBDetent: SheetDetent = .medium
    @State private var sheetBStartOffset: CGFloat = UIScreen.main.bounds.height // Start off-screen
    
    var body: some View {
        ZStack {
            // Map Background
            Map()
                .ignoresSafeArea()
            
            // SheetA - only show if sheetB hasn't reached medium or if sheetB is not present
            if showSheetA && (!showSheetB || !sheetBHasReachedMedium) {
                CustomSheet(
                    detent: $sheetADetent,
                    content: {
                        SheetAContent {
                            // Button action to show sheetB
                            showSheetB = true
                            
                            // Animate sheetB moving up from off-screen
                            withAnimation(.easeInOut(duration: 0.6)) {
                                sheetBStartOffset = 0 // Move to normal position
                            }
                            
                            // After animation completes, hide sheetA
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                sheetBHasReachedMedium = true
                            }
                        }
                    }
                )
            }
            
            // SheetB - overlay on top, starts off-screen
            if showSheetB {
                CustomSheet(
                    detent: $sheetBDetent,
                    content: {
                        SheetBContent {
                            // Close button action - show sheetA immediately, then animate sheetB out
                            // Immediately restore sheetA
                            sheetBHasReachedMedium = false
                            
                            // Animate sheetB moving down off-screen
                            withAnimation(.easeInOut(duration: 0.4)) {
                                sheetBStartOffset = UIScreen.main.bounds.height // Move off-screen
                            }
                            
                            // After animation completes, clean up sheetB
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                showSheetB = false
                                sheetBDetent = .medium // Reset for next time
                                sheetBStartOffset = UIScreen.main.bounds.height // Reset position
                            }
                        }
                    }
                )
                .offset(y: sheetBStartOffset)
            }
        }
    }
}

// MARK: - Sheet Detent Enum
enum SheetDetent: CaseIterable {
    case small // height(100)
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 100
        case .medium: return UIScreen.main.bounds.height * 0.5
        case .large: return UIScreen.main.bounds.height * 0.9
        }
    }
}

// MARK: - Custom Sheet Component
struct CustomSheet<Content: View>: View {
    @Binding var detent: SheetDetent
    let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    init(detent: Binding<SheetDetent>, @ViewBuilder content: () -> Content) {
        self._detent = detent
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 6)
                    .padding(.top, 8)
                
                // Content
                content
                    .frame(maxWidth: .infinity)
                    .frame(height: detent.height - 20) // Account for handle
                    .clipped()
                
                Spacer(minLength: 0)
            }
            .frame(height: detent.height)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(radius: 10)
            )
            .offset(y: dragOffset)
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height - (detent.height / 2)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.height
                    }
                    .onEnded { value in
                        isDragging = false
                        
                        let newDetent = calculateNewDetent(
                            currentDetent: detent,
                            dragDistance: value.translation.height,
                            velocity: value.velocity.height
                        )
                        
                        withAnimation(.easeOut(duration: 0.3)) {
                            detent = newDetent
                            dragOffset = 0
                        }
                    }
            )
            .animation(.easeOut(duration: 0.3), value: detent)
        }
    }
    
    private func calculateNewDetent(currentDetent: SheetDetent, dragDistance: CGFloat, velocity: CGFloat) -> SheetDetent {
        let threshold: CGFloat = 50
        let velocityThreshold: CGFloat = 500
        
        // Strong velocity takes precedence
        if abs(velocity) > velocityThreshold {
            if velocity > 0 { // Dragging down
                switch currentDetent {
                case .large: return .medium
                case .medium: return .small
                case .small: return .small // Can't go smaller
                }
            } else { // Dragging up
                switch currentDetent {
                case .small: return .medium
                case .medium: return .large
                case .large: return .large // Can't go larger
                }
            }
        }
        
        // Distance-based decision
        if abs(dragDistance) > threshold {
            if dragDistance > 0 { // Dragging down
                switch currentDetent {
                case .large: return .medium
                case .medium: return .small
                case .small: return .small
                }
            } else { // Dragging up
                switch currentDetent {
                case .small: return .medium
                case .medium: return .large
                case .large: return .large
                }
            }
        }
        
        // Default: stay at current detent
        return currentDetent
    }
}

// MARK: - Sheet Content Views
struct SheetAContent: View {
    let onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sheet A")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("This is the first sheet with a map background")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: onButtonTap) {
                Text("Show Sheet B")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct SheetBContent: View {
    let onCloseTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Sheet B")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onCloseTap) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("This is the second sheet that covers Sheet A")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Text("Sheet A is hidden while this sheet is present")
                .font(.caption)
                .foregroundColor(.tertiary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SandboxView()
}
