struct HumidifierWaterBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            HumidifierWaterBalanceInput
    ) throws
        -> HumidifierWaterBalanceResult {

        let values = [
            input.dryGasMassFlow,
            input.inletHumidityRatio,
            input.outletHumidityRatio
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HumidifierWaterBalanceError
                .nonFiniteInput
        }

        guard input.dryGasMassFlow > 0 else {
            throw HumidifierWaterBalanceError
                .nonPositiveDryGasFlow
        }

        guard
            input.inletHumidityRatio >= 0,
            input.outletHumidityRatio >= 0
        else {
            throw HumidifierWaterBalanceError
                .negativeHumidityRatio
        }

        guard
            input.outletHumidityRatio
            >= input.inletHumidityRatio
        else {
            throw HumidifierWaterBalanceError
                .invalidHumidificationTarget
        }

        let inletWater =
            input.dryGasMassFlow
            * input.inletHumidityRatio

        let outletWater =
            input.dryGasMassFlow
            * input.outletHumidityRatio

        let waterAdded =
            outletWater
            - inletWater

        let inletHumidGas =
            input.dryGasMassFlow
            + inletWater

        let outletHumidGas =
            input.dryGasMassFlow
            + outletWater

        let outletWaterFraction =
            outletWater
            / outletHumidGas

        let flowIncrease =
            outletHumidGas
            / inletHumidGas
            - 1

        let outputs = [
            inletWater,
            outletWater,
            waterAdded,
            inletHumidGas,
            outletHumidGas,
            outletWaterFraction,
            flowIncrease
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            outletWaterFraction <= 1
        else {
            throw HumidifierWaterBalanceError
                .numericalFailure
        }

        return .init(
            inletWaterVaporFlow:
                inletWater,
            outletWaterVaporFlow:
                outletWater,
            waterAddedFlow:
                max(0, waterAdded),
            inletHumidGasFlow:
                inletHumidGas,
            outletHumidGasFlow:
                outletHumidGas,
            outletWaterMassFraction:
                outletWaterFraction,
            humidGasFlowIncreaseFraction:
                max(0, flowIncrease),
            modelName:
                "Dry-gas-basis humidifier water balance",
            limitationDescription:
                "Humidity ratio is kilograms of water vapor per kilogram of dry gas. Energy balance, saturation limits and liquid carryover are excluded."
        )
    }
}
