import Foundation
enum NaturalCubicSplineInterpolationError: Error, Equatable, LocalizedError { case invalidData, nonFiniteInput, nonIncreasingX, queryOutOfRange
 var errorDescription:String? { switch self { case .invalidData:return "At least two paired data points are required."; case .nonFiniteInput:return "All values must be finite."; case .nonIncreasingX:return "x values must be strictly increasing."; case .queryOutOfRange:return "The query must lie inside the data range." } } }
