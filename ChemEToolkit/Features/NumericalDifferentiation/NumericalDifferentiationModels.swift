import Foundation

enum NumericalDifferentiationMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case forward
    case backward
    case central

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .forward:
            return "Forward Difference"

        case .backward:
            return "Backward Difference"

        case .central:
            return "Central Difference"
        }
    }

    var pickerTitle: String {
        switch self {
        case .forward:
            return "Forward"

        case .backward:
            return "Backward"

        case .central:
            return "Central"
        }
    }

    var formula: String {
        switch self {
        case .forward:
            return """
            f′(xᵢ) ≈ [f(xᵢ₊₁) − f(xᵢ)] / [xᵢ₊₁ − xᵢ]
            """

        case .backward:
            return """
            f′(xᵢ) ≈ [f(xᵢ) − f(xᵢ₋₁)] / [xᵢ − xᵢ₋₁]
            """

        case .central:
            return """
            f′(xᵢ) ≈ [f(xᵢ₊₁) − f(xᵢ₋₁)] / (2h)
            """
        }
    }

    var explanation: String {
        switch self {
        case .forward:
            return """
            Uses the selected data point and the next available point.
            """

        case .backward:
            return """
            Uses the selected data point and the previous available point.
            """

        case .central:
            return """
            Uses points on both sides of the selected point. Unequally spaced data is also supported.
            """
        }
    }

    var minimumPointCount: Int {
        switch self {
        case .forward, .backward:
            return 2

        case .central:
            return 3
        }
    }
}

struct DifferentiationPoint:
    Equatable,
    Hashable {

    let x: Double
    let y: Double
}

struct NumericalDifferentiationInput:
    Equatable {

    let points: [DifferentiationPoint]
    let targetX: Double
}

struct NumericalDifferentiationResult:
    Equatable {

    let method: NumericalDifferentiationMethod

    let targetX: Double
    let derivative: Double

    let pointCount: Int
    let usedPoints: [DifferentiationPoint]

    let lowerBound: Double
    let upperBound: Double

    let isEquallySpaced: Bool
    let spacing: Double?
}
