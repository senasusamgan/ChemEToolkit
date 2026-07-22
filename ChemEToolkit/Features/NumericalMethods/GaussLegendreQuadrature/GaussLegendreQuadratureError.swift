import Foundation
enum GaussLegendreQuadratureError: Error, Equatable, LocalizedError { case invalidBounds, unsupportedOrder
 var errorDescription:String? { self == .invalidBounds ? "Bounds must be finite and distinct." : "Supported quadrature orders are 2 through 5." } }
