import Foundation

struct ODESolverEngine {
    private let comparisonTolerance = 1e-12

    func solve(
        method: ODESolverMethod,
        input: ODESolverInput
    ) throws -> ODESolverResult {
        try validateInput(input)

        let direction =
            input.targetX > input.initialX
            ? 1.0
            : -1.0

        let nominalStep =
            direction * input.stepSize

        var currentX = input.initialX
        var currentY = input.initialY

        var points: [ODESolutionPoint] = [
            ODESolutionPoint(
                step: 0,
                x: currentX,
                y: currentY,
                derivative:
                    input.coefficients.derivative(
                        x: currentX,
                        y: currentY
                    )
            )
        ]

        var stepCount = 0
        var adjustedFinalStep = false

        let targetTolerance =
            comparisonTolerance *
            max(
                1,
                abs(input.targetX)
            )

        while direction *
                (input.targetX - currentX) >
                targetTolerance {

            guard stepCount <
                    input.maximumSteps else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "The required number of steps exceeds the selected maximum."
                    )
            }

            let remainingDistance =
                input.targetX - currentX

            let currentStep: Double

            if abs(remainingDistance) <
                input.stepSize {
                currentStep = remainingDistance
                adjustedFinalStep = true
            } else {
                currentStep = nominalStep
            }

            let nextY = try calculateNextValue(
                method: method,
                coefficients:
                    input.coefficients,
                x: currentX,
                y: currentY,
                step: currentStep
            )

            let nextX =
                currentX + currentStep

            let validatedX =
                try InputValidator.validateResult(
                    nextX
                )

            let validatedY =
                try InputValidator.validateResult(
                    nextY
                )

            currentX = validatedX
            currentY = validatedY
            stepCount += 1

            points.append(
                ODESolutionPoint(
                    step: stepCount,
                    x: currentX,
                    y: currentY,
                    derivative:
                        input.coefficients.derivative(
                            x: currentX,
                            y: currentY
                        )
                )
            )
        }

        return ODESolverResult(
            method: method,
            points: points,
            initialX: input.initialX,
            initialY: input.initialY,
            targetX: input.targetX,
            finalX: currentX,
            finalY: currentY,
            stepSize: input.stepSize,
            stepCount: stepCount,
            adjustedFinalStep:
                adjustedFinalStep
        )
    }

    private func calculateNextValue(
        method: ODESolverMethod,
        coefficients: ODEEquationCoefficients,
        x: Double,
        y: Double,
        step: Double
    ) throws -> Double {
        let result: Double

        switch method {
        case .euler:
            let slope =
                coefficients.derivative(
                    x: x,
                    y: y
                )

            result =
                y + step * slope

        case .heun:
            let firstSlope =
                coefficients.derivative(
                    x: x,
                    y: y
                )

            let predictedY =
                y + step * firstSlope

            let secondSlope =
                coefficients.derivative(
                    x: x + step,
                    y: predictedY
                )

            result =
                y +
                step *
                (
                    firstSlope +
                    secondSlope
                ) / 2

        case .rungeKuttaFourth:
            let firstSlope =
                coefficients.derivative(
                    x: x,
                    y: y
                )

            let secondSlope =
                coefficients.derivative(
                    x: x + step / 2,
                    y:
                        y +
                        step *
                        firstSlope / 2
                )

            let thirdSlope =
                coefficients.derivative(
                    x: x + step / 2,
                    y:
                        y +
                        step *
                        secondSlope / 2
                )

            let fourthSlope =
                coefficients.derivative(
                    x: x + step,
                    y:
                        y +
                        step *
                        thirdSlope
                )

            result =
                y +
                step *
                (
                    firstSlope +
                    2 * secondSlope +
                    2 * thirdSlope +
                    fourthSlope
                ) / 6
        }

        return try InputValidator.validateResult(
            result
        )
    }

    private func validateInput(
        _ input: ODESolverInput
    ) throws {
        let values = [
            input.coefficients.constant,
            input.coefficients.xCoefficient,
            input.coefficients.yCoefficient,
            input.coefficients.xyCoefficient,
            input.initialX,
            input.initialY,
            input.targetX,
            input.stepSize
        ]

        guard values.allSatisfy({
            $0.isFinite
        }) else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "All equation and interval values must be finite numbers."
                )
        }

        guard input.initialX !=
                input.targetX else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The target x value must be different from the initial x value."
                )
        }

        _ = try InputValidator.requirePositive(
            input.stepSize,
            fieldName: "Step Size"
        )

        guard
            input.maximumSteps >= 1,
            input.maximumSteps <= 100_000
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Maximum steps must be an integer between 1 and 100,000."
                )
        }
    }
}
