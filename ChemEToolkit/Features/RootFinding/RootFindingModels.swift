import Foundation

enum RootFindingMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case bisection
    case newtonRaphson
    case secant

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .bisection:
            return "Bisection Method"

        case .newtonRaphson:
            return "Newton–Raphson Method"

        case .secant:
            return "Secant Method"
        }
    }

    var pickerTitle: String {
        switch self {
        case .bisection:
            return "Bisection"

        case .newtonRaphson:
            return "Newton"

        case .secant:
            return "Secant"
        }
    }

    var formula: String {
        switch self {
        case .bisection:
            return "c = (a + b) / 2"

        case .newtonRaphson:
            return "xₙ₊₁ = xₙ − f(xₙ) / f′(xₙ)"

        case .secant:
            return "xₙ₊₁ = xₙ − f(xₙ)(xₙ − xₙ₋₁) / [f(xₙ) − f(xₙ₋₁)]"
        }
    }

    var explanation: String {
        switch self {
        case .bisection:
            return """
            A reliable bracketing method. The function must have opposite signs at the two interval bounds.
            """

        case .newtonRaphson:
            return """
            Uses the polynomial derivative and one initial guess. It usually converges rapidly near a root.
            """

        case .secant:
            return """
            Uses two initial guesses and does not require an explicitly entered derivative.
            """
        }
    }
}

struct RootFindingInput: Equatable {
    /// Ascending powers:
    /// [a₀, a₁, a₂, ...]
    let coefficients: [Double]

    let lowerBound: Double?
    let upperBound: Double?

    let initialGuess: Double?
    let secondGuess: Double?

    let tolerance: Double
    let maximumIterations: Int
}

struct RootIteration:
    Identifiable,
    Equatable {

    let iteration: Int
    let x: Double
    let functionValue: Double
    let estimatedError: Double

    var id: Int {
        iteration
    }
}

struct RootFindingResult: Equatable {
    let method: RootFindingMethod

    let root: Double
    let functionValue: Double

    let iterations: Int
    let converged: Bool
    let tolerance: Double

    let polynomialDegree: Int
    let history: [RootIteration]
}
