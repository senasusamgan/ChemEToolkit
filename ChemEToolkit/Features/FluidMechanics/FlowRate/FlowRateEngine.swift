struct FlowRateEngine {

    func solve(
        input: FlowRateInput
    ) throws -> FlowRateResult {

        try validate(input)

        let area =
            Double.pi
            * input.diameter
            * input.diameter
            / 4

        let volumetricFlowRate =
            area
            * input.averageVelocity

        let massFlowRate =
            input.density
            * volumetricFlowRate

        guard area.isFinite,
              volumetricFlowRate.isFinite,
              massFlowRate.isFinite else {
            throw FlowRateError
                .nonFiniteResult
        }

        return FlowRateResult(
            diameter:
                input.diameter,
            averageVelocity:
                input.averageVelocity,
            density:
                input.density,
            crossSectionalArea:
                area,
            volumetricFlowRate:
                volumetricFlowRate,
            massFlowRate:
                massFlowRate
        )
    }

    private func validate(
        _ input: FlowRateInput
    ) throws {

        guard input.diameter.isFinite,
              input.diameter > 0 else {
            throw FlowRateError
                .invalidDiameter
        }

        guard input.averageVelocity.isFinite,
              input.averageVelocity >= 0 else {
            throw FlowRateError
                .invalidVelocity
        }

        guard input.density.isFinite,
              input.density > 0 else {
            throw FlowRateError
                .invalidDensity
        }
    }
}
