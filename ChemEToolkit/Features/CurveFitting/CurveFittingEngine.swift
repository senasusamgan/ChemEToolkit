import Foundation

struct CurveFittingEngine {
    private let numericalThreshold = 1e-12

    private let linearSystemEngine =
        LinearSystemEngine()

    func fit(
        input: CurveFittingInput
    ) throws -> CurveFittingResult {
        let degree = try validatedDegree(
            method: input.method,
            requestedDegree:
                input.polynomialDegree
        )

        try validatePoints(
            input.points,
            degree: degree
        )

        let sortedPoints =
            input.points.sorted {
                $0.x < $1.x
            }

        let lowerBound =
            sortedPoints[0].x

        let upperBound =
            sortedPoints[
                sortedPoints.count - 1
            ].x

        let xMean =
            sortedPoints
                .map(\.x)
                .reduce(0, +) /
            Double(sortedPoints.count)

        let xScale =
            sortedPoints
                .map {
                    abs($0.x - xMean)
                }
                .max() ?? 0

        guard xScale > numericalThreshold else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Regression requires variation in the x values."
                )
        }

        let normalizedPoints =
            sortedPoints.map {
                RegressionPoint(
                    x:
                        ($0.x - xMean) /
                        xScale,
                    y: $0.y
                )
            }

        let normalizedCoefficients =
            try calculateLeastSquaresCoefficients(
                points: normalizedPoints,
                degree: degree
            )

        let coefficients =
            convertNormalizedCoefficients(
                normalizedCoefficients,
                mean: xMean,
                scale: xScale
            )

        let validatedCoefficients =
            try coefficients.map {
                try InputValidator
                    .validateResult($0)
            }

        let fittedValues =
            sortedPoints.map {
                evaluatePolynomial(
                    coefficients:
                        validatedCoefficients,
                    at: $0.x
                )
            }

        let validatedFittedValues =
            try fittedValues.map {
                try InputValidator
                    .validateResult($0)
            }

        let residuals = zip(
            sortedPoints,
            validatedFittedValues
        )
        .map { point, fittedValue in
            point.y - fittedValue
        }

        let validatedResiduals =
            try residuals.map {
                try InputValidator
                    .validateResult($0)
            }

        let sumSquaredErrors =
            validatedResiduals.reduce(0) {
                partialResult,
                residual in

                partialResult +
                residual * residual
            }

        let yMean =
            sortedPoints
                .map(\.y)
                .reduce(0, +) /
            Double(sortedPoints.count)

        let totalSumSquares =
            sortedPoints.reduce(0) {
                partialResult,
                point in

                let difference =
                    point.y - yMean

                return partialResult +
                    difference * difference
            }

        let rSquared: Double

        if totalSumSquares <=
            numericalThreshold {

            rSquared =
                sumSquaredErrors <=
                    numericalThreshold
                ? 1
                : 0
        } else {
            rSquared =
                1 -
                sumSquaredErrors /
                totalSumSquares
        }

        let rmse = sqrt(
            sumSquaredErrors /
            Double(sortedPoints.count)
        )

        let predictedY: Double?

        if let predictionX =
            input.predictionX {

            guard predictionX.isFinite else {
                throw CalculationError
                    .invalidNumber(
                        fieldName:
                            "Prediction x"
                    )
            }

            predictedY =
                try InputValidator
                    .validateResult(
                        evaluatePolynomial(
                            coefficients:
                                validatedCoefficients,
                            at: predictionX
                        )
                    )
        } else {
            predictedY = nil
        }

        let isExtrapolation: Bool

        if let predictionX =
            input.predictionX {

            isExtrapolation =
                predictionX < lowerBound ||
                predictionX > upperBound
        } else {
            isExtrapolation = false
        }

        return CurveFittingResult(
            method: input.method,
            degree: degree,
            coefficients:
                validatedCoefficients,
            fittedValues:
                validatedFittedValues,
            residuals:
                validatedResiduals,
            rSquared:
                try InputValidator
                    .validateResult(
                        rSquared
                    ),
            rmse:
                try InputValidator
                    .validateResult(
                        rmse
                    ),
            pointCount:
                sortedPoints.count,
            lowerBound: lowerBound,
            upperBound: upperBound,
            predictionX:
                input.predictionX,
            predictedY: predictedY,
            isExtrapolation:
                isExtrapolation
        )
    }

    func evaluatePolynomial(
        coefficients: [Double],
        at x: Double
    ) -> Double {
        coefficients.reversed().reduce(0) {
            partialResult,
            coefficient in

            partialResult * x +
            coefficient
        }
    }

    private func validatedDegree(
        method: CurveFittingMethod,
        requestedDegree: Int
    ) throws -> Int {
        switch method {
        case .linear:
            return 1

        case .polynomial:
            guard 2...4 ~=
                    requestedDegree else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "Polynomial regression degree must be between 2 and 4."
                    )
            }

            return requestedDegree
        }
    }

    private func validatePoints(
        _ points: [RegressionPoint],
        degree: Int
    ) throws {
        let minimumPointCount =
            degree + 1

        guard points.count >=
                minimumPointCount else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "At least \(minimumPointCount) data points are required for a degree \(degree) regression."
                )
        }

        guard points.count <= 500 else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "A maximum of 500 data points is supported."
                )
        }

        let allValuesAreFinite =
            points.allSatisfy {
                $0.x.isFinite &&
                $0.y.isFinite
            }

        guard allValuesAreFinite else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "All x and y values must be finite numbers."
                )
        }
    }

    private func calculateLeastSquaresCoefficients(
        points: [RegressionPoint],
        degree: Int
    ) throws -> [Double] {
        let coefficientCount =
            degree + 1

        var normalMatrix = Array(
            repeating:
                Array(
                    repeating: 0.0,
                    count: coefficientCount
                ),
            count: coefficientCount
        )

        var normalConstants = Array(
            repeating: 0.0,
            count: coefficientCount
        )

        for row in 0..<coefficientCount {
            for column in
                0..<coefficientCount {

                normalMatrix[row][column] =
                    points.reduce(0) {
                        partialResult,
                        point in

                        partialResult +
                        pow(
                            point.x,
                            Double(
                                row +
                                column
                            )
                        )
                    }
            }

            normalConstants[row] =
                points.reduce(0) {
                    partialResult,
                    point in

                    partialResult +
                    point.y *
                    pow(
                        point.x,
                        Double(row)
                    )
                }
        }

        let linearInput =
            LinearSystemInput(
                coefficientMatrix:
                    normalMatrix,
                constants:
                    normalConstants,
                initialGuess: nil,
                tolerance: 1e-12,
                maximumIterations: 100
            )

        do {
            let result =
                try linearSystemEngine.solve(
                    method:
                        .gaussianElimination,
                    input: linearInput
                )

            return result.solution
        } catch {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The selected regression model could not be fitted. Try lowering the polynomial degree or adding more varied x values."
                )
        }
    }

    private func convertNormalizedCoefficients(
        _ normalizedCoefficients:
            [Double],
        mean: Double,
        scale: Double
    ) -> [Double] {
        var originalCoefficients =
            Array(
                repeating: 0.0,
                count:
                    normalizedCoefficients.count
            )

        for normalizedPower in
            normalizedCoefficients.indices {

            let normalizedCoefficient =
                normalizedCoefficients[
                    normalizedPower
                ]

            let scaleFactor =
                pow(
                    scale,
                    Double(normalizedPower)
                )

            for originalPower in
                0...normalizedPower {

                let binomial =
                    binomialCoefficient(
                        n: normalizedPower,
                        k: originalPower
                    )

                let meanPower =
                    pow(
                        -mean,
                        Double(
                            normalizedPower -
                            originalPower
                        )
                    )

                originalCoefficients[
                    originalPower
                ] +=
                    normalizedCoefficient /
                    scaleFactor *
                    binomial *
                    meanPower
            }
        }

        return originalCoefficients
    }

    private func binomialCoefficient(
        n: Int,
        k: Int
    ) -> Double {
        guard
            k >= 0,
            k <= n
        else {
            return 0
        }

        let effectiveK =
            min(k, n - k)

        guard effectiveK > 0 else {
            return 1
        }

        var result = 1.0

        for index in 1...effectiveK {
            result *=
                Double(
                    n -
                    effectiveK +
                    index
                )

            result /=
                Double(index)
        }

        return result
    }
}
