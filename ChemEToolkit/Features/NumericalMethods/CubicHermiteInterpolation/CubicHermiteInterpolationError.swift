import Foundation
enum CubicHermiteInterpolationError: Error, Equatable, LocalizedError { case nonFiniteInput, invalidInterval, queryOutOfRange
 var errorDescription:String? { switch self { case .nonFiniteInput:return "All inputs must be finite."; case .invalidInterval:return "x1 must be greater than x0."; case .queryOutOfRange:return "The query must lie between the endpoints." } } }
