import Testing
@testable import ChemEToolkit

@Suite("Root Finding Engine")
struct RootFindingEngineTests {
    private let engine =
        RootFindingEngine()

    private let tolerance =
        0.000001

    private var squareRootTwoInput:
        RootFindingInput {
        RootFindingInput(
            coefficients: [
                -2,
                0,
                1
            ],
            lowerBound: 0,
            upperBound: 2,
            initialGuess: 1,
            secondGuess: 2,
            tolerance: 1e-10,
            maximumIterations: 100
        )
    }

    @Test("Calculates root using bisection")
    func calculatesBisectionRoot() throws {
        let result = try engine.solve(
            method: .bisection,
            input: squareRootTwoInput
        )

        #expect(result.converged)

        #expect(
            abs(
                result.root -
                1.4142135623730951
            ) < tolerance
        )

        #expect(
            abs(result.functionValue) <
            tolerance
        )
    }

    @Test("Calculates root using Newton Raphson")
    func calculatesNewtonRoot() throws {
        let result = try engine.solve(
            method: .newtonRaphson,
            input: squareRootTwoInput
        )

        #expect(result.converged)

        #expect(
            abs(
                result.root -
                1.4142135623730951
            ) < tolerance
        )
    }

    @Test("Calculates root using Secant Method")
    func calculatesSecantRoot() throws {
        let result = try engine.solve(
            method: .secant,
            input: squareRootTwoInput
        )

        #expect(result.converged)

        #expect(
            abs(
                result.root -
                1.4142135623730951
            ) < tolerance
        )
    }

    @Test("Evaluates polynomial")
    func evaluatesPolynomial() {
        let value =
            engine.evaluatePolynomial(
                coefficients: [
                    -2,
                    0,
                    1
                ],
                at: 2
            )

        #expect(value == 2)
    }

    @Test("Returns exact endpoint root")
    func returnsEndpointRoot() throws {
        let input = RootFindingInput(
            coefficients: [
                0,
                -1,
                1
            ],
            lowerBound: 0,
            upperBound: 2,
            initialGuess: nil,
            secondGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        let result = try engine.solve(
            method: .bisection,
            input: input
        )

        #expect(result.root == 0)
        #expect(result.iterations == 0)
        #expect(result.converged)
    }

    @Test("Rejects invalid bisection interval")
    func rejectsInvalidBracket() {
        let input = RootFindingInput(
            coefficients: [
                1,
                0,
                1
            ],
            lowerBound: -1,
            upperBound: 1,
            initialGuess: nil,
            secondGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Bisection Method requires the function to have opposite signs at the interval bounds."
                    )
        ) {
            try engine.solve(
                method: .bisection,
                input: input
            )
        }
    }

    @Test("Rejects Newton near-zero derivative")
    func rejectsZeroDerivative() {
        let input = RootFindingInput(
            coefficients: [
                1,
                0,
                0,
                1
            ],
            lowerBound: nil,
            upperBound: nil,
            initialGuess: 0,
            secondGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Newton–Raphson Method encountered a near-zero derivative. Try a different initial guess."
                    )
        ) {
            try engine.solve(
                method: .newtonRaphson,
                input: input
            )
        }
    }

    @Test("Rejects identical Secant function values")
    func rejectsIdenticalFunctionValues() {
        let input = RootFindingInput(
            coefficients: [
                1,
                0,
                1
            ],
            lowerBound: nil,
            upperBound: nil,
            initialGuess: -1,
            secondGuess: 1,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Secant Method encountered nearly identical function values. Try different initial guesses."
                    )
        ) {
            try engine.solve(
                method: .secant,
                input: input
            )
        }
    }

    @Test("Returns non-converged result at iteration limit")
    func returnsNonConvergedResult() throws {
        let input = RootFindingInput(
            coefficients: [
                -2,
                0,
                1
            ],
            lowerBound: 0,
            upperBound: 2,
            initialGuess: nil,
            secondGuess: nil,
            tolerance: 1e-15,
            maximumIterations: 1
        )

        let result = try engine.solve(
            method: .bisection,
            input: input
        )

        #expect(result.converged == false)
        #expect(result.iterations == 1)
    }
}
