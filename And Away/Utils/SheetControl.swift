import SwiftUI

// MARK: - Shared Sheet Configurations
struct SheetDefaults {
    static let standardDetents: Set<PresentationDetent> = [.height(100), .medium, .fraction(0.99)]
    static let defaultDetent: PresentationDetent = .medium
    static let backgroundInteractionEnabled = true
    static let dismissDisabled = true
}

enum SheetLevel: CaseIterable {
    case list, details, third
    
    var index: Int {
        switch self {
        case .list: return 0
        case .details: return 1
        case .third: return 2
        }
    }
}

class SheetController: ObservableObject {
    @Published var sheetDetents: [PresentationDetent] = [.medium, .medium, .medium]
    @Published var activeSheets: Set<SheetLevel> = [.list] // Start with list open
    @Published var hasTemporaryDetents: Set<SheetLevel> = []
    
    private var savedDetents: [PresentationDetent] = [.medium, .medium, .medium]
    
    func presentSheet(_ level: SheetLevel) {
        // Save current detent of all active sheets before changing
        for activeLevel in activeSheets {
            savedDetents[activeLevel.index] = sheetDetents[activeLevel.index]
        }
        
        // Add new sheet to active set
        activeSheets.insert(level)
        
        // Move all previously active sheets to medium first
        for activeLevel in activeSheets where activeLevel != level {
            sheetDetents[activeLevel.index] = .medium
        }
        
        // After delay, minimize all sheets except the newest one
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for activeLevel in self.activeSheets where activeLevel != level {
                self.hasTemporaryDetents.insert(activeLevel)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.sheetDetents[activeLevel.index] = .height(1)
                }
            }
        }
    }
    
    func dismissSheet(_ level: SheetLevel) {
        activeSheets.remove(level)
        hasTemporaryDetents.remove(level)
        
        // Reset dismissed sheet to default position (forget its detent)
        sheetDetents[level.index] = .medium
        savedDetents[level.index] = .medium
        
        // Restore remaining sheets to their saved positions
        for activeLevel in activeSheets {
            hasTemporaryDetents.remove(activeLevel)
            sheetDetents[activeLevel.index] = savedDetents[activeLevel.index]
        }
    }
    
    func getDetents(for level: SheetLevel) -> Set<PresentationDetent> {
        let baseDetents: Set<PresentationDetent> = [.height(100), .medium, .large]
        
        if hasTemporaryDetents.contains(level) {
            return baseDetents.union([.height(1)])
        }
        return baseDetents
    }
    
    func getDetent(for level: SheetLevel) -> Binding<PresentationDetent> {
        Binding(
            get: { self.sheetDetents[level.index] },
            set: { self.sheetDetents[level.index] = $0 }
        )
    }
    
    func setKeyboardVisible(_ isVisible: Bool, for level: SheetLevel) {
        if isVisible {
            // When keyboard appears, change to large detent to prevent animation issues
            sheetDetents[level.index] = .large
        } else {
            // When keyboard disappears, return to medium detent
            sheetDetents[level.index] = .medium
        }
    }
}

extension View {
    func managedSheetDetents(controller: SheetController, level: SheetLevel) -> some View {
        self.presentationDetents(
            controller.getDetents(for: level),
            selection: controller.getDetent(for: level)
        )
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(24)
    }
}
