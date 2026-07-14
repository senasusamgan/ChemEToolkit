import Foundation

enum NumericalIntegrationMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case trapezoidal
    case simpsonOneThird

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .trapezoidal:
            return "Trapezoidal Rule"

        case .simpsonOneThird:
            return "Simpson’s 1/3 Rule"
        }
    }

    var pickerTitle: String {
        switch self {
        case .trapezoidal:
            return "Trapezoidal"

        case .simpsonOneThird:
            return "Simpson 1/3"
        }
    }

    var formula: String {
        switch self {
        case .trapezoidal:
            return "I ≈ Σ [(xᵢ₊₁ − xᵢ)(yᵢ + yᵢ₊₁) / 2]"

        case .simpsonOneThird:
            return "I ≈ h/3 [y₀ + yₙ + 4Σyₒdd + 2Σyₑven]"
        }
    }

    var explanation: String {
        switch self {
        case .trapezoidal:
            return """
            Supports both equally and unequally spaced data points.
            """

        case .simpsonOneThird:
            return """
            Requires equally spaced x values and an even number of subintervals.
            """
        }
    }

    var minimumPointCount: Int {
        switch self {
        case .trapezoidal:
            return 2

        case .simpsonOneThird:
            return 3
        }
    }
}

struct IntegrationPoint:
    Equatable,
    Hashable {

    let x: Double
    let y: Double
}

struct NumericalIntegrationInput:
    Equatable {

    let points: [IntegrationPoint]
}

struct NumericalIntegrationResult:
    Equatable {

    let method: NumericalIntegrationMethod
    let value: Double

    let pointCount: Int
    let intervalCount: Int

    let lowerBound: Double
    let upperBound: Double

    let isEquallySpaced: Bool
    let spacing: Double?
}
