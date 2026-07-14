struct PressureDropEngine {

    private let reynoldsNumberEngine =
        ReynoldsNumberEngine()

    private let frictionFactorEngine =
        FrictionFactorEngine()

    func solve(
        input: PressureDropInput
    ) throws -> PressureDropResult {

        try validate(input)

        let reynoldsResult =
            try reynoldsNumberEngine.solve(
                input: ReynoldsNumberInput(
                    velocity:
                        input.averageVelocity,
                    diameter:
                        input.pipeDiameter,
                    viscosity: .dynamic(
                        density:
                            input.density,
                        dynamicViscosity:
                            input.dynamicViscosity
                    )
                )
            )

        let frictionFactorResult =
            try frictionFactorEngine.solve(
                input: FrictionFactorInput(
                    reynoldsNumber:
                        reynoldsResult
                            .reynoldsNumber,
                    pipeDiameter:
                        input.pipeDiameter,
                    absoluteRoughness:
                        input.absoluteRoughness
                )
            )

        let velocityHead =
            input.averageVelocity
            * input.averageVelocity
            / (2 * input.gravity)

        let headLoss =
            frictionFactorResult
                .darcyFrictionFactor
            * (
                input.pipeLength
                / input.pipeDiameter
            )
            * velocityHead

        let pressureDrop =
            input.density
            * input.gravity
            * headLoss

        guard
            velocityHead.isFinite,
            headLoss.isFinite,
            pressureDrop.isFinite
        else {
            throw PressureDropError
                .nonFiniteResult
        }

        return PressureDropResult(
            reynoldsNumber:
                reynoldsResult
                    .reynoldsNumber,
            flowRegime:
                reynoldsResult
                    .flowRegime,
            darcyFrictionFactor:
                frictionFactorResult
                    .darcyFrictionFactor,
            fanningFrictionFactor:
                frictionFactorResult
                    .fanningFrictionFactor,
            relativeRoughness:
                frictionFactorResult
                    .relativeRoughness,
            velocityHead:
                velocityHead,
            headLoss:
                headLoss,
            pressureDrop:
                pressureDrop,
            pipeLength:
                input.pipeLength
        )
    }

    private func validate(
        _ input: PressureDropInput
    ) throws {

        guard
            input.pipeLength.isFinite,
            input.pipeLength > 0
        else {
            throw PressureDropError
                .invalidPipeLength
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw PressureDropError
                .invalidGravity
        }
    }
}
