import Foundation
enum AdaptiveSimpsonIntegrationFunction: String, CaseIterable, Equatable, Sendable { case square, exponentialDecay, gaussian }
struct AdaptiveSimpsonIntegrationInput: Equatable, Sendable {
    let function: AdaptiveSimpsonIntegrationFunction
    let lowerBound: Double
    let upperBound: Double
    let tolerance: Double
    let maximumDepth: Int
    init(function: AdaptiveSimpsonIntegrationFunction, lowerBound: Double, upperBound: Double, tolerance: Double = 1e-9, maximumDepth: Int = 20) { self.function=function; self.lowerBound=lowerBound; self.upperBound=upperBound; self.tolerance=tolerance; self.maximumDepth=maximumDepth }
}
