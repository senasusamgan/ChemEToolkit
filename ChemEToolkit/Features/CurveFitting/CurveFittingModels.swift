import Foundation

enum CurveFittingMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case linear
    case polynomial

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .linear:
            return "Linear Regression"

        case .polynomial:
            return "Polynomial Regression"
        }
    }

    var pickerTitle: String {
        switch self {
        case .linear:
            return "Linear"

        case .polynomial:
            return "Polynomial"
        }
    }

    var explanation: String {
        switch self {
        case .linear:
            return """
            Fits the best straight line to the entered data using the least-squares method.
            """

        case .polynomial:
            return """
            Fits a polynomial of the selected degree to the entered data using least squares.
            """
        }
    }
}

struct RegressionPoint:
    Equatable,
    Hashable {

    let x: Double
    let y: Double
}

struct CurveFittingInput:
    Equatable {

    let method: CurveFittingMethod
    let polynomialDegree: Int

    let points: [RegressionPoint]

    let predictionX: Double?
}

struct CurveFittingResult:
    Equatable {

    let method: CurveFittingMethod
    let degree: Int

    /// Ascending powers:
    /// [a₀, a₁, a₂, ...]
    let coefficients: [Double]

    let fittedValues: [Double]
    let residuals: [Double]

    let rSquared: Double
    let rmse: Double

    let pointCount: Int

    let lowerBound: Double
    let upperBound: Double

    let predictionX: Double?
    let predictedY: Double?

    let isExtrapolation: Bool
}
