struct MinorLossEngine {

    func solve(
        input: MinorLossInput
    ) throws -> MinorLossResult {

        try validate(input)

        let totalLossCoefficient =
            input.lossCoefficients.reduce(
                0,
                +
            )

        let velocityHead =
            input.averageVelocity
            * input.averageVelocity
            / (2 * input.gravity)

        let headLoss =
            totalLossCoefficient
            * velocityHead

        let pressureDrop =
            input.density
            * input.gravity
            * headLoss

        guard
            totalLossCoefficient.isFinite,
            velocityHead.isFinite,
            headLoss.isFinite,
            pressureDrop.isFinite
        else {
            throw MinorLossError
                .nonFiniteResult
        }

        return MinorLossResult(
            lossCoefficients:
                input.lossCoefficients,
            totalLossCoefficient:
                totalLossCoefficient,
            velocityHead:
                velocityHead,
            headLoss:
                headLoss,
            pressureDrop:
                pressureDrop
        )
    }

    private func validate(
        _ input: MinorLossInput
    ) throws {

        guard
            input.density.isFinite,
            input.density > 0
        else {
            throw MinorLossError
                .invalidDensity
        }

        guard
            input.averageVelocity.isFinite,
            input.averageVelocity >= 0
        else {
            throw MinorLossError
                .invalidVelocity
        }

        guard
            !input.lossCoefficients.isEmpty
        else {
            throw MinorLossError
                .missingLossCoefficients
        }

        guard input.lossCoefficients.allSatisfy({
            $0.isFinite && $0 >= 0
        }) else {
            throw MinorLossError
                .invalidLossCoefficient
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw MinorLossError
                .invalidGravity
        }
    }
}
