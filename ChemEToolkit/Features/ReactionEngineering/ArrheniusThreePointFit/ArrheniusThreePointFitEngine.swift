import Foundation

struct ArrheniusThreePointFitEngine:
    Sendable {

    private let gasConstant = 8.31446261815324
    private let comparisonTolerance = 1.0e-12

    func calculate(
        _ input: ArrheniusThreePointFitInput
    ) throws -> ArrheniusThreePointFitResult {
        let temperatures = [
            input.temperatureOne,
            input.temperatureTwo,
            input.temperatureThree
        ]

        let rateConstants = [
            input.rateConstantOne,
            input.rateConstantTwo,
            input.rateConstantThree
        ]

        guard
            (temperatures + rateConstants)
            .allSatisfy(\.isFinite)
        else {
            throw ArrheniusThreePointFitError.nonFiniteInput
        }

        guard
            temperatures.allSatisfy({ $0 > 0 }),
            rateConstants.allSatisfy({ $0 > 0 })
        else {
            throw ArrheniusThreePointFitError
                .nonPositiveTemperatureOrRateConstant
        }

        guard
            abs(temperatures[0] - temperatures[1])
            > comparisonTolerance,
            abs(temperatures[0] - temperatures[2])
            > comparisonTolerance,
            abs(temperatures[1] - temperatures[2])
            > comparisonTolerance
        else {
            throw ArrheniusThreePointFitError.duplicateTemperatures
        }

        let x = temperatures.map { 1 / $0 }
        let y = rateConstants.map(log)

        let xMean = x.reduce(0, +) / 3
        let yMean = y.reduce(0, +) / 3

        let sxx =
            zip(x, x)
            .reduce(0) {
                $0
                + ($1.0 - xMean)
                * ($1.1 - xMean)
            }

        let sxy =
            zip(x, y)
            .reduce(0) {
                $0
                + ($1.0 - xMean)
                * ($1.1 - yMean)
            }

        guard sxx > 0 else {
            throw ArrheniusThreePointFitError.duplicateTemperatures
        }

        let slope = sxy / sxx
        let intercept = yMean - slope * xMean

        let activationEnergy =
            -slope * gasConstant

        guard activationEnergy > 0 else {
            throw ArrheniusThreePointFitError.nonPositiveActivationEnergy
        }

        let preExponentialFactor =
            exp(intercept)

        let predictedLnK =
            x.map {
                intercept + slope * $0
            }

        let predictedRateConstants =
            predictedLnK.map(exp)

        let totalSumSquares =
            y.reduce(0) {
                $0
                + ($1 - yMean)
                * ($1 - yMean)
            }

        let residualSumSquares =
            zip(y, predictedLnK)
            .reduce(0) {
                $0
                + ($1.0 - $1.1)
                * ($1.0 - $1.1)
            }

        let rSquared =
            totalSumSquares > 0
            ? 1 - residualSumSquares / totalSumSquares
            : 1

        let relativeResiduals =
            zip(
                rateConstants,
                predictedRateConstants
            )
            .map {
                abs($0.0 - $0.1)
                / $0.0
            }

        let maximumResidual =
            relativeResiduals.max() ?? 0

        guard
            [
                slope,
                intercept,
                activationEnergy,
                preExponentialFactor,
                rSquared,
                maximumResidual
            ]
            .allSatisfy(\.isFinite),
            preExponentialFactor > 0,
            rSquared <= 1 + 1.0e-10,
            maximumResidual >= 0
        else {
            throw ArrheniusThreePointFitError.numericalFailure
        }

        let fitDescription: String

        if rSquared >= 0.995 {
            fitDescription =
                "The three points are highly consistent with a single Arrhenius line."
        } else if rSquared >= 0.98 {
            fitDescription =
                "The Arrhenius fit is reasonable, but measurable curvature or experimental scatter is present."
        } else {
            fitDescription =
                "The data show substantial deviation from a single Arrhenius line."
        }

        return .init(
            activationEnergy:
                activationEnergy,
            activationEnergyKilojoulesPerMole:
                activationEnergy / 1000,
            preExponentialFactor:
                preExponentialFactor,
            slope: slope,
            intercept: intercept,
            coefficientOfDetermination:
                min(1, rSquared),
            predictedRateConstantOne:
                predictedRateConstants[0],
            predictedRateConstantTwo:
                predictedRateConstants[1],
            predictedRateConstantThree:
                predictedRateConstants[2],
            maximumRelativeResidual:
                maximumResidual,
            fitQualityDescription:
                fitDescription,
            modelName:
                "Three-point least-squares Arrhenius linearization of ln(k) versus 1/T"
        )
    }
}
