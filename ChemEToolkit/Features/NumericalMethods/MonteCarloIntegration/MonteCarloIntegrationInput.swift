import Foundation
enum MonteCarloIntegrationFunction: String, CaseIterable, Equatable, Sendable { case square, exponentialDecay, gaussian }
struct MonteCarloIntegrationInput: Equatable, Sendable {
    let function: MonteCarloIntegrationFunction
    let lowerBound: Double
    let upperBound: Double
    let sampleCount: Int
    let seed: UInt64
    init(function: MonteCarloIntegrationFunction, lowerBound: Double, upperBound: Double, sampleCount: Int = 100000, seed: UInt64 = 42) { self.function=function; self.lowerBound=lowerBound; self.upperBound=upperBound; self.sampleCount=sampleCount; self.seed=seed }
}
