import Testing
@testable import ChemEToolkit

@Suite("Curve Fitting Engine")
struct CurveFittingEngineTests {
    private let engine =
        CurveFittingEngine()

    private let tolerance =
        0.000001

    @Test("Fits exact linear regression")
    func fitsLinearRegression() throws {
        let input = CurveFittingInput(
            method: .linear,
            polynomialDegree: 1,
            points: [
                RegressionPoint(x: 0, y: 1),
                RegressionPoint(x: 1, y: 3),
                RegressionPoint(x: 2, y: 5),
                RegressionPoint(x: 3, y: 7)
            ],
            predictionX: 1.5
        )

        let result =
            try engine.fit(input: input)

        #expect(result.degree == 1)

        #expect(
            abs(
                result.coefficients[0] -
                1
            ) < tolerance
        )

        #expect(
            abs(
                result.coefficients[1] -
                2
            ) < tolerance
        )

        #expect(
            abs(result.rSquared - 1) <
            tolerance
        )

        #expect(
            result.rmse < tolerance
        )

        #expect(
            abs(
                (result.predictedY ?? 0) -
                4
            ) < tolerance
        )

        #expect(
            result.isExtrapolation ==
            false
        )
    }

    @Test("Fits exact quadratic regression")
    func fitsQuadraticRegression() throws {
        let input = CurveFittingInput(
            method: .polynomial,
            polynomialDegree: 2,
            points: [
                RegressionPoint(x: 0, y: 1),
                RegressionPoint(x: 1, y: 2),
                RegressionPoint(x: 2, y: 5),
                RegressionPoint(x: 3, y: 10)
            ],
            predictionX: 1.5
        )

        let result =
            try engine.fit(input: input)

        #expect(result.degree == 2)

        #expect(
            abs(
                result.coefficients[0] -
                1
            ) < tolerance
        )

        #expect(
            abs(
                result.coefficients[1]
            ) < tolerance
        )

        #expect(
            abs(
                result.coefficients[2] -
                1
            ) < tolerance
        )

        #expect(
            abs(
                (result.predictedY ?? 0) -
                3.25
            ) < tolerance
        )

        #expect(
            result.rSquared >
            0.999999
        )
    }

    @Test("Detects extrapolation")
    func detectsExtrapolation() throws {
        let input = CurveFittingInput(
            method: .linear,
            polynomialDegree: 1,
            points: [
                RegressionPoint(x: 0, y: 1),
                RegressionPoint(x: 1, y: 3),
                RegressionPoint(x: 2, y: 5)
            ],
            predictionX: 4
        )

        let result =
            try engine.fit(input: input)

        #expect(result.isExtrapolation)

        #expect(
            abs(
                (result.predictedY ?? 0) -
                9
            ) < tolerance
        )
    }

    @Test("Fits constant response")
    func fitsConstantResponse() throws {
        let input = CurveFittingInput(
            method: .linear,
            polynomialDegree: 1,
            points: [
                RegressionPoint(x: 0, y: 5),
                RegressionPoint(x: 1, y: 5),
                RegressionPoint(x: 2, y: 5)
            ],
            predictionX: nil
        )

        let result =
            try engine.fit(input: input)

        #expect(
            abs(
                result.coefficients[0] -
                5
            ) < tolerance
        )

        #expect(
            abs(
                result.coefficients[1]
            ) < tolerance
        )

        #expect(
            abs(result.rSquared - 1) <
            tolerance
        )
    }

    @Test("Evaluates polynomial")
    func evaluatesPolynomial() {
        let value =
            engine.evaluatePolynomial(
                coefficients: [
                    1,
                    2,
                    3
                ],
                at: 2
            )

        #expect(value == 17)
    }

    @Test("Rejects insufficient points")
    func rejectsInsufficientPoints() {
        let input = CurveFittingInput(
            method: .polynomial,
            polynomialDegree: 3,
            points: [
                RegressionPoint(x: 0, y: 0),
                RegressionPoint(x: 1, y: 1),
                RegressionPoint(x: 2, y: 4)
            ],
            predictionX: nil
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "At least 4 data points are required for a degree 3 regression."
                    )
        ) {
            try engine.fit(input: input)
        }
    }

    @Test("Rejects invalid polynomial degree")
    func rejectsInvalidDegree() {
        let input = CurveFittingInput(
            method: .polynomial,
            polynomialDegree: 5,
            points: [
                RegressionPoint(x: 0, y: 0),
                RegressionPoint(x: 1, y: 1),
                RegressionPoint(x: 2, y: 4),
                RegressionPoint(x: 3, y: 9),
                RegressionPoint(x: 4, y: 16),
                RegressionPoint(x: 5, y: 25)
            ],
            predictionX: nil
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Polynomial regression degree must be between 2 and 4."
                    )
        ) {
            try engine.fit(input: input)
        }
    }

    @Test("Rejects identical x values")
    func rejectsIdenticalXValues() {
        let input = CurveFittingInput(
            method: .linear,
            polynomialDegree: 1,
            points: [
                RegressionPoint(x: 1, y: 2),
                RegressionPoint(x: 1, y: 3),
                RegressionPoint(x: 1, y: 4)
            ],
            predictionX: nil
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Regression requires variation in the x values."
                    )
        ) {
            try engine.fit(input: input)
        }
    }
}
