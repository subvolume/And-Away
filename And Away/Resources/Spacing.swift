// Spacing.swift 
import SwiftUI // Or UIKit, depending on your project

// Spacing.swift
// This file defines standard spacing units used throughout the app.

struct Spacing {
    /// Micro spacing (e.g. icon nudge) - 2
    static let xxxs: CGFloat = 2
    /// Very tight spacing - 4
    static let xxs: CGFloat = 4
    /// Between small labels/icons - 8
    static let xs: CGFloat = 8
    /// Tight layout blocks - 12
    static let s: CGFloat = 12
    /// Standard content padding - 18
    static let m: CGFloat = 18 // Changed from 16 to 18
    /// Section or block separation - 24
    static let l: CGFloat = 24
    /// Modal/page padding - 32
    static let xl: CGFloat = 32
    /// Hero sections, outer container - 40+
    static let xxl: CGFloat = 40 // We'll start with 40, can be adjusted or added to
} 