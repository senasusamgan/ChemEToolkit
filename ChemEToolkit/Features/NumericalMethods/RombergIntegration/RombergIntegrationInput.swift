import Foundation
enum RombergIntegrationFunction: String, CaseIterable, Equatable, Sendable { case square, exponentialDecay, gaussian }
struct RombergIntegrationInput: Equatable, Sendable {
    let function: RombergIntegrationFunction
    let lowerBound: Double
    let upperBound: Double
    let levels: Int
    init(function: RombergIntegrationFunction, lowerBound: Double, upperBound: Double, levels: Int = 6) { self.function=function; self.lowerBound=lowerBound; self.upperBound=upperBound; self.levels=levels }
}
