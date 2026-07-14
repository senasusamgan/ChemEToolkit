struct HydrostaticPressureEngine {

    func solve(
        input: HydrostaticPressureInput
    ) throws -> HydrostaticPressureResult {

        try validate(input)

        let pressureIncrease =
            input.fluidDensity
            * input.gravity
            * input.depth

        let pressureAtDepth =
            input.surfacePressure
            + pressureIncrease

        let pressureHead =
            pressureIncrease
            / (
                input.fluidDensity
                * input.gravity
            )

        guard
            pressureIncrease.isFinite,
            pressureAtDepth.isFinite,
            pressureHead.isFinite
        else {
            throw HydrostaticPressureError
                .nonFiniteResult
        }

        return HydrostaticPressureResult(
            surfacePressure:
                input.surfacePressure,
            pressureIncrease:
                pressureIncrease,
            pressureAtDepth:
                pressureAtDepth,
            pressureHead:
                pressureHead,
            depth:
                input.depth
        )
    }

    private func validate(
        _ input: HydrostaticPressureInput
    ) throws {

        guard
            input.fluidDensity.isFinite,
            input.fluidDensity > 0
        else {
            throw HydrostaticPressureError
                .invalidFluidDensity
        }

        guard
            input.depth.isFinite,
            input.depth >= 0
        else {
            throw HydrostaticPressureError
                .invalidDepth
        }

        guard
            input.surfacePressure.isFinite
        else {
            throw HydrostaticPressureError
                .invalidSurfacePressure
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw HydrostaticPressureError
                .invalidGravity
        }
    }
}
