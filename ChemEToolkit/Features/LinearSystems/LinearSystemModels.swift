import Foundation

enum LinearSystemMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case gaussianElimination
    case gaussSeidel

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .gaussianElimination:
            return "Gaussian Elimination"

        case .gaussSeidel:
            return "Gauss–Seidel Method"
        }
    }

    var pickerTitle: String {
        switch self {
        case .gaussianElimination:
            return "Gaussian"

        case .gaussSeidel:
            return "Gauss–Seidel"
        }
    }

    var formula: String {
        switch self {
        case .gaussianElimination:
            return "Ax = b → Upper Triangular Form → Back Substitution"

        case .gaussSeidel:
            return "xᵢ⁽ᵏ⁺¹⁾ = [bᵢ − Σⱼ≠ᵢ aᵢⱼxⱼ] / aᵢᵢ"
        }
    }

    var explanation: String {
        switch self {
        case .gaussianElimination:
            return """
            Solves a square linear system directly using partial pivoting for improved numerical stability.
            """

        case .gaussSeidel:
            return """
            Updates each unknown iteratively using the newest available estimates. Diagonally dominant systems generally converge more reliably.
            """
        }
    }
}

struct LinearSystemInput: Equatable {
    let coefficientMatrix: [[Double]]
    let constants: [Double]

    let initialGuess: [Double]?

    let tolerance: Double
    let maximumIterations: Int
}

struct LinearSystemIteration:
    Identifiable,
    Equatable {

    let iteration: Int
    let estimates: [Double]

    let residualNorm: Double
    let maximumChange: Double

    var id: Int {
        iteration
    }
}

struct LinearSystemResult: Equatable {
    let method: LinearSystemMethod

    let solution: [Double]
    let residualNorm: Double

    let iterations: Int
    let converged: Bool

    let systemSize: Int
    let history: [LinearSystemIteration]
}
