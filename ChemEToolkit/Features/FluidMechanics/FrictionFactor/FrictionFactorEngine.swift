import Foundation

struct FrictionFactorEngine {

    func solve(
        input: FrictionFactorInput
    ) throws -> FrictionFactorResult {

        try validate(input)

        let relativeRoughness =
            input.absoluteRoughness
            / input.pipeDiameter

        let flowRegime =
            FlowRegime.classify(
                reynoldsNumber:
                    input.reynoldsNumber
            )

        let darcyFrictionFactor: Double
        let iterationCount: Int

        switch flowRegime {
        case .laminar:
            darcyFrictionFactor =
                64 / input.reynoldsNumber

            iterationCount = 0

        case .transitional:
            throw FrictionFactorError
                .transitionalFlowUnsupported

        case .turbulent:
            let solution =
                try solveColebrookWhite(
                    reynoldsNumber:
                        input.reynoldsNumber,
                    relativeRoughness:
                        relativeRoughness,
                    tolerance:
                        input.tolerance,
                    maximumIterations:
                        input.maximumIterations
                )

            darcyFrictionFactor =
                solution.factor

            iterationCount =
                solution.iterations
        }

        let fanningFrictionFactor =
            darcyFrictionFactor / 4

        guard
            darcyFrictionFactor.isFinite,
            darcyFrictionFactor > 0,
            fanningFrictionFactor.isFinite
        else {
            throw FrictionFactorError
                .nonFiniteResult
        }

        return FrictionFactorResult(
            reynoldsNumber:
                input.reynoldsNumber,
            pipeDiameter:
                input.pipeDiameter,
            absoluteRoughness:
                input.absoluteRoughness,
            relativeRoughness:
                relativeRoughness,
            darcyFrictionFactor:
                darcyFrictionFactor,
            fanningFrictionFactor:
                fanningFrictionFactor,
            flowRegime:
                flowRegime,
            iterationCount:
                iterationCount
        )
    }

    private func solveColebrookWhite(
        reynoldsNumber: Double,
        relativeRoughness: Double,
        tolerance: Double,
        maximumIterations: Int
    ) throws -> (
        factor: Double,
        iterations: Int
    ) {
        var frictionFactor =
            initialTurbulentGuess(
                reynoldsNumber:
                    reynoldsNumber,
                relativeRoughness:
                    relativeRoughness
            )

        for iteration in
            1...maximumIterations {

            let squareRoot =
                sqrt(frictionFactor)

            let logarithmArgument =
                relativeRoughness / 3.7
                + 2.51
                / (
                    reynoldsNumber
                    * squareRoot
                )

            guard
                logarithmArgument.isFinite,
                logarithmArgument > 0
            else {
                throw FrictionFactorError
                    .nonFiniteResult
            }

            let denominator =
                -2
                * log10(
                    logarithmArgument
                )

            let nextFactor =
                1
                / (
                    denominator
                    * denominator
                )

            guard
                nextFactor.isFinite,
                nextFactor > 0
            else {
                throw FrictionFactorError
                    .nonFiniteResult
            }

            if abs(
                nextFactor
                - frictionFactor
            ) <= tolerance {
                return (
                    factor: nextFactor,
                    iterations: iteration
                )
            }

            frictionFactor =
                nextFactor
        }

        throw FrictionFactorError
            .iterationDidNotConverge
    }

    private func initialTurbulentGuess(
        reynoldsNumber: Double,
        relativeRoughness: Double
    ) -> Double {

        let logarithmArgument =
            relativeRoughness / 3.7
            + 5.74
            / pow(
                reynoldsNumber,
                0.9
            )

        let logarithm =
            log10(
                logarithmArgument
            )

        let guess =
            0.25
            / (
                logarithm
                * logarithm
            )

        guard
            guess.isFinite,
            guess > 0
        else {
            return 0.02
        }

        return guess
    }

    private func validate(
        _ input: FrictionFactorInput
    ) throws {

        guard
            input.reynoldsNumber.isFinite,
            input.reynoldsNumber > 0
        else {
            throw FrictionFactorError
                .invalidReynoldsNumber
        }

        guard
            input.pipeDiameter.isFinite,
            input.pipeDiameter > 0
        else {
            throw FrictionFactorError
                .invalidPipeDiameter
        }

        guard
            input.absoluteRoughness.isFinite,
            input.absoluteRoughness >= 0
        else {
            throw FrictionFactorError
                .invalidAbsoluteRoughness
        }

        guard
            input.absoluteRoughness
                < input.pipeDiameter
        else {
            throw FrictionFactorError
                .roughnessExceedsDiameter
        }

        guard
            input.tolerance.isFinite,
            input.tolerance > 0
        else {
            throw FrictionFactorError
                .invalidTolerance
        }

        guard
            input.maximumIterations > 0
        else {
            throw FrictionFactorError
                .invalidMaximumIterations
        }
    }
}
