import Foundation

enum NumericalInterpolationMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case linear
    case lagrange

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .linear:
            return "Linear Interpolation"

        case .lagrange:
            return "Lagrange Interpolation"
        }
    }

    var pickerTitle: String {
        switch self {
        case .linear:
            return "Linear"

        case .lagrange:
            return "Lagrange"
        }
    }

    var formula: String {
        switch self {
        case .linear:
            return """
            y = y₁ + (x − x₁)(y₂ − y₁) / (x₂ − x₁)
            """

        case .lagrange:
            return """
            P(x) = Σ yᵢ ∏ [(x − xⱼ) / (xᵢ − xⱼ)]
            """
        }
    }

    var explanation: String {
        switch self {
        case .linear:
            return """
            Estimates a value between two known data points using a straight line.
            """

        case .lagrange:
            return """
            Constructs a polynomial passing through all entered data points.
            """
        }
    }

    var minimumPointCount: Int {
        2
    }

    var requiredPointCount: Int? {
        switch self {
        case .linear:
            return 2

        case .lagrange:
            return nil
        }
    }
}

struct InterpolationPoint:
    Equatable,
    Hashable {

    let x: Double
    let y: Double
}

struct NumericalInterpolationInput:
    Equatable {

    let points: [InterpolationPoint]
    let targetX: Double
}

struct NumericalInterpolationResult:
    Equatable {

    let method: NumericalInterpolationMethod
    let targetX: Double
    let interpolatedY: Double

    let pointCount: Int
    let lowerBound: Double
    let upperBound: Double

    let isExtrapolation: Bool
    let polynomialDegree: Int
}
