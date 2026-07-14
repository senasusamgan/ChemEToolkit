struct PumpPowerEngine {

    func solve(
        input: PumpPowerInput
    ) throws -> PumpPowerResult {

        try validate(input)

        let pressureIncrease =
            input.density
            * input.gravity
            * input.pumpHead

        let hydraulicPower =
            pressureIncrease
            * input.volumetricFlowRate

        let shaftPower =
            hydraulicPower
            / input.efficiency

        guard
            pressureIncrease.isFinite,
            hydraulicPower.isFinite,
            shaftPower.isFinite
        else {
            throw PumpPowerError
                .nonFiniteResult
        }

        return PumpPowerResult(
            pressureIncrease:
                pressureIncrease,
            hydraulicPower:
                hydraulicPower,
            shaftPower:
                shaftPower,
            volumetricFlowRate:
                input.volumetricFlowRate,
            pumpHead:
                input.pumpHead,
            efficiency:
                input.efficiency
        )
    }

    private func validate(
        _ input: PumpPowerInput
    ) throws {

        guard
            input.density.isFinite,
            input.density > 0
        else {
            throw PumpPowerError
                .invalidDensity
        }

        guard
            input.volumetricFlowRate
                .isFinite,
            input.volumetricFlowRate >= 0
        else {
            throw PumpPowerError
                .invalidFlowRate
        }

        guard
            input.pumpHead.isFinite,
            input.pumpHead >= 0
        else {
            throw PumpPowerError
                .invalidPumpHead
        }

        guard
            input.efficiency.isFinite,
            input.efficiency > 0,
            input.efficiency <= 1
        else {
            throw PumpPowerError
                .invalidEfficiency
        }

        guard
            input.gravity.isFinite,
            input.gravity > 0
        else {
            throw PumpPowerError
                .invalidGravity
        }
    }
}
