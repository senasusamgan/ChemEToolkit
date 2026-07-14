import Foundation

struct RootFindingEngine {
    private let numericalThreshold = 1e-14

    func solve(
        method: RootFindingMethod,
        input: RootFindingInput
    ) throws -> RootFindingResult {
        let coefficients =
            try validatedCoefficients(
                input.coefficients
            )

        let tolerance =
            try InputValidator.requirePositive(
                input.tolerance,
                fieldName: "Tolerance"
            )

        guard
            input.maximumIterations >= 1,
            input.maximumIterations <= 10_000
        else {
            throw CalculationError.calculationFailed(
                reason:
                    "Maximum iterations must be an integer between 1 and 10,000."
            )
        }

        switch method {
        case .bisection:
            return try solveBisection(
                coefficients: coefficients,
                lowerBound: input.lowerBound,
                upperBound: input.upperBound,
                tolerance: tolerance,
                maximumIterations:
                    input.maximumIterations
            )

        case .newtonRaphson:
            return try solveNewtonRaphson(
                coefficients: coefficients,
                initialGuess: input.initialGuess,
                tolerance: tolerance,
                maximumIterations:
                    input.maximumIterations
            )

        case .secant:
            return try solveSecant(
                coefficients: coefficients,
                firstGuess: input.initialGuess,
                secondGuess: input.secondGuess,
                tolerance: tolerance,
                maximumIterations:
                    input.maximumIterations
            )
        }
    }

    func evaluatePolynomial(
        coefficients: [Double],
        at x: Double
    ) -> Double {
        coefficients.reversed().reduce(0) {
            partialResult,
            coefficient in

            partialResult * x + coefficient
        }
    }

    private func solveBisection(
        coefficients: [Double],
        lowerBound: Double?,
        upperBound: Double?,
        tolerance: Double,
        maximumIterations: Int
    ) throws -> RootFindingResult {
        guard let lowerBound else {
            throw CalculationError.emptyField(
                fieldName: "Lower Bound"
            )
        }

        guard let upperBound else {
            throw CalculationError.emptyField(
                fieldName: "Upper Bound"
            )
        }

        guard lowerBound < upperBound else {
            throw CalculationError.calculationFailed(
                reason:
                    "The lower bound must be smaller than the upper bound."
            )
        }

        var lower = lowerBound
        var upper = upperBound

        var lowerValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: lower
            )

        let initialUpperValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: upper
            )

        if abs(lowerValue) <= tolerance {
            return exactResult(
                method: .bisection,
                coefficients: coefficients,
                root: lower,
                tolerance: tolerance
            )
        }

        if abs(initialUpperValue) <= tolerance {
            return exactResult(
                method: .bisection,
                coefficients: coefficients,
                root: upper,
                tolerance: tolerance
            )
        }

        guard haveOppositeSigns(
            lowerValue,
            initialUpperValue
        ) else {
            throw CalculationError.calculationFailed(
                reason:
                    "Bisection Method requires the function to have opposite signs at the interval bounds."
            )
        }

        var history: [RootIteration] = []

        var lastMidpoint =
            (lower + upper) / 2

        var lastValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: lastMidpoint
            )

        for iteration in 1...maximumIterations {
            let midpoint =
                (lower + upper) / 2

            let midpointValue =
                evaluatePolynomial(
                    coefficients: coefficients,
                    at: midpoint
                )

            let estimatedError =
                abs(upper - lower) / 2

            history.append(
                RootIteration(
                    iteration: iteration,
                    x: midpoint,
                    functionValue:
                        midpointValue,
                    estimatedError:
                        estimatedError
                )
            )

            lastMidpoint = midpoint
            lastValue = midpointValue

            if abs(midpointValue) <= tolerance ||
                estimatedError <= tolerance {
                return makeResult(
                    method: .bisection,
                    coefficients: coefficients,
                    root: midpoint,
                    functionValue:
                        midpointValue,
                    tolerance: tolerance,
                    converged: true,
                    history: history
                )
            }

            if haveOppositeSigns(
                lowerValue,
                midpointValue
            ) {
                upper = midpoint
            } else {
                lower = midpoint
                lowerValue = midpointValue
            }
        }

        return makeResult(
            method: .bisection,
            coefficients: coefficients,
            root: lastMidpoint,
            functionValue: lastValue,
            tolerance: tolerance,
            converged: false,
            history: history
        )
    }

    private func solveNewtonRaphson(
        coefficients: [Double],
        initialGuess: Double?,
        tolerance: Double,
        maximumIterations: Int
    ) throws -> RootFindingResult {
        guard var currentX = initialGuess else {
            throw CalculationError.emptyField(
                fieldName: "Initial Guess"
            )
        }

        let initialValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: currentX
            )

        if abs(initialValue) <= tolerance {
            return exactResult(
                method: .newtonRaphson,
                coefficients: coefficients,
                root: currentX,
                tolerance: tolerance
            )
        }

        var history: [RootIteration] = []

        for iteration in 1...maximumIterations {
            let evaluation =
                evaluatePolynomialAndDerivative(
                    coefficients: coefficients,
                    at: currentX
                )

            let derivativeScale = max(
                1,
                abs(evaluation.value)
            )

            guard abs(evaluation.derivative) >
                    numericalThreshold *
                    derivativeScale
            else {
                throw CalculationError.calculationFailed(
                    reason:
                        "Newton–Raphson Method encountered a near-zero derivative. Try a different initial guess."
                )
            }

            let nextX =
                currentX -
                evaluation.value /
                evaluation.derivative

            let validatedNextX =
                try InputValidator.validateResult(
                    nextX
                )

            let nextValue =
                evaluatePolynomial(
                    coefficients: coefficients,
                    at: validatedNextX
                )

            let estimatedError =
                abs(validatedNextX - currentX)

            history.append(
                RootIteration(
                    iteration: iteration,
                    x: validatedNextX,
                    functionValue: nextValue,
                    estimatedError:
                        estimatedError
                )
            )

            if abs(nextValue) <= tolerance ||
                estimatedError <= tolerance {
                return makeResult(
                    method: .newtonRaphson,
                    coefficients: coefficients,
                    root: validatedNextX,
                    functionValue: nextValue,
                    tolerance: tolerance,
                    converged: true,
                    history: history
                )
            }

            currentX = validatedNextX
        }

        let lastIteration = history.last

        return makeResult(
            method: .newtonRaphson,
            coefficients: coefficients,
            root: lastIteration?.x ?? currentX,
            functionValue:
                lastIteration?.functionValue ??
                initialValue,
            tolerance: tolerance,
            converged: false,
            history: history
        )
    }

    private func solveSecant(
        coefficients: [Double],
        firstGuess: Double?,
        secondGuess: Double?,
        tolerance: Double,
        maximumIterations: Int
    ) throws -> RootFindingResult {
        guard var firstX = firstGuess else {
            throw CalculationError.emptyField(
                fieldName: "First Guess"
            )
        }

        guard var secondX = secondGuess else {
            throw CalculationError.emptyField(
                fieldName: "Second Guess"
            )
        }

        guard firstX != secondX else {
            throw CalculationError.calculationFailed(
                reason:
                    "The two Secant Method initial guesses must be different."
            )
        }

        var firstValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: firstX
            )

        var secondValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: secondX
            )

        if abs(firstValue) <= tolerance {
            return exactResult(
                method: .secant,
                coefficients: coefficients,
                root: firstX,
                tolerance: tolerance
            )
        }

        if abs(secondValue) <= tolerance {
            return exactResult(
                method: .secant,
                coefficients: coefficients,
                root: secondX,
                tolerance: tolerance
            )
        }

        var history: [RootIteration] = []

        for iteration in 1...maximumIterations {
            let denominator =
                secondValue - firstValue

            let scale = max(
                1,
                max(
                    abs(firstValue),
                    abs(secondValue)
                )
            )

            guard abs(denominator) >
                    numericalThreshold * scale
            else {
                throw CalculationError.calculationFailed(
                    reason:
                        "Secant Method encountered nearly identical function values. Try different initial guesses."
                )
            }

            let nextX =
                secondX -
                secondValue *
                (secondX - firstX) /
                denominator

            let validatedNextX =
                try InputValidator.validateResult(
                    nextX
                )

            let nextValue =
                evaluatePolynomial(
                    coefficients: coefficients,
                    at: validatedNextX
                )

            let estimatedError =
                abs(validatedNextX - secondX)

            history.append(
                RootIteration(
                    iteration: iteration,
                    x: validatedNextX,
                    functionValue: nextValue,
                    estimatedError:
                        estimatedError
                )
            )

            if abs(nextValue) <= tolerance ||
                estimatedError <= tolerance {
                return makeResult(
                    method: .secant,
                    coefficients: coefficients,
                    root: validatedNextX,
                    functionValue: nextValue,
                    tolerance: tolerance,
                    converged: true,
                    history: history
                )
            }

            firstX = secondX
            firstValue = secondValue

            secondX = validatedNextX
            secondValue = nextValue
        }

        return makeResult(
            method: .secant,
            coefficients: coefficients,
            root: secondX,
            functionValue: secondValue,
            tolerance: tolerance,
            converged: false,
            history: history
        )
    }

    private func validatedCoefficients(
        _ coefficients: [Double]
    ) throws -> [Double] {
        guard !coefficients.isEmpty else {
            throw CalculationError.calculationFailed(
                reason:
                    "At least one polynomial coefficient is required."
            )
        }

        guard coefficients.allSatisfy({
            $0.isFinite
        }) else {
            throw CalculationError.calculationFailed(
                reason:
                    "All polynomial coefficients must be finite numbers."
            )
        }

        var trimmedCoefficients =
            coefficients

        while
            trimmedCoefficients.count > 1,
            abs(trimmedCoefficients.last ?? 0) <=
                numericalThreshold {
            trimmedCoefficients.removeLast()
        }

        guard trimmedCoefficients.contains(
            where: {
                abs($0) >
                    numericalThreshold
            }
        ) else {
            throw CalculationError.calculationFailed(
                reason:
                    "The polynomial cannot contain only zero coefficients."
            )
        }

        return trimmedCoefficients
    }

    private func evaluatePolynomialAndDerivative(
        coefficients: [Double],
        at x: Double
    ) -> (
        value: Double,
        derivative: Double
    ) {
        guard let leadingCoefficient =
                coefficients.last
        else {
            return (0, 0)
        }

        var value = leadingCoefficient
        var derivative = 0.0

        for coefficient in
            coefficients.dropLast().reversed() {
            derivative =
                derivative * x + value

            value =
                value * x + coefficient
        }

        return (
            value,
            derivative
        )
    }

    private func exactResult(
        method: RootFindingMethod,
        coefficients: [Double],
        root: Double,
        tolerance: Double
    ) -> RootFindingResult {
        let functionValue =
            evaluatePolynomial(
                coefficients: coefficients,
                at: root
            )

        return makeResult(
            method: method,
            coefficients: coefficients,
            root: root,
            functionValue: functionValue,
            tolerance: tolerance,
            converged: true,
            history: [
                RootIteration(
                    iteration: 0,
                    x: root,
                    functionValue:
                        functionValue,
                    estimatedError: 0
                )
            ]
        )
    }

    private func makeResult(
        method: RootFindingMethod,
        coefficients: [Double],
        root: Double,
        functionValue: Double,
        tolerance: Double,
        converged: Bool,
        history: [RootIteration]
    ) -> RootFindingResult {
        RootFindingResult(
            method: method,
            root: root,
            functionValue: functionValue,
            iterations:
                history.last?.iteration ?? 0,
            converged: converged,
            tolerance: tolerance,
            polynomialDegree:
                coefficients.count - 1,
            history: history
        )
    }

    private func haveOppositeSigns(
        _ firstValue: Double,
        _ secondValue: Double
    ) -> Bool {
        (
            firstValue < 0 &&
            secondValue > 0
        ) ||
        (
            firstValue > 0 &&
            secondValue < 0
        )
    }
}
