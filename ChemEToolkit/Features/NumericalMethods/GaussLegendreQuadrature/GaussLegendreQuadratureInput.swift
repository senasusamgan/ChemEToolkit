import Foundation
enum GaussLegendreQuadratureFunction: String, CaseIterable, Equatable, Sendable { case square, exponentialDecay, gaussian }
struct GaussLegendreQuadratureInput: Equatable, Sendable {
    let function: GaussLegendreQuadratureFunction
    let lowerBound: Double
    let upperBound: Double
    let order: Int
    init(function: GaussLegendreQuadratureFunction, lowerBound: Double, upperBound: Double, order: Int = 5) { self.function=function; self.lowerBound=lowerBound; self.upperBound=upperBound; self.order=order }
}
