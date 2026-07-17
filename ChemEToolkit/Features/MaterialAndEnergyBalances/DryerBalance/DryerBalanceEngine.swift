struct DryerBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            DryerBalanceInput
    ) throws
        -> DryerBalanceResult {

        let values = [
            input.wetFeedMassFlow,
            input.initialMoistureWetBasis,
            input.targetMoistureWetBasis
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DryerBalanceError
                .nonFiniteInput
        }

        guard input.wetFeedMassFlow > 0 else {
            throw DryerBalanceError
                .nonPositiveFeedFlow
        }

        let moistures = [
            input.initialMoistureWetBasis,
            input.targetMoistureWetBasis
        ]

        guard
            moistures.allSatisfy({
                $0 >= 0 && $0 < 1
            })
        else {
            throw DryerBalanceError
                .invalidMoistureFraction
        }

        guard
            input.targetMoistureWetBasis
            <= input.initialMoistureWetBasis
        else {
            throw DryerBalanceError
                .invalidDryingTarget
        }

        let initialWater =
            input.wetFeedMassFlow
            * input.initialMoistureWetBasis

        let drySolids =
            input.wetFeedMassFlow
            - initialWater

        let driedProduct =
            drySolids
            / (
                1
                - input.targetMoistureWetBasis
            )

        let finalWater =
            driedProduct
            - drySolids

        let waterRemoved =
            initialWater
            - finalWater

        let initialDryBasis =
            initialWater
            / drySolids

        let finalDryBasis =
            finalWater
            / drySolids

        let removalFraction =
            initialWater > 0
            ? waterRemoved
                / initialWater
            : 0

        let outputs = [
            drySolids,
            initialWater,
            driedProduct,
            finalWater,
            waterRemoved,
            initialDryBasis,
            finalDryBasis,
            removalFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            removalFraction <= 1 + 1e-12
        else {
            throw DryerBalanceError
                .numericalFailure
        }

        return .init(
            drySolidFlow:
                drySolids,
            initialWaterFlow:
                initialWater,
            driedProductFlow:
                driedProduct,
            finalWaterFlow:
                finalWater,
            waterRemovedFlow:
                max(
                    0,
                    waterRemoved
                ),
            initialMoistureDryBasis:
                initialDryBasis,
            finalMoistureDryBasis:
                finalDryBasis,
            waterRemovalFraction:
                min(
                    1,
                    max(
                        0,
                        removalFraction
                    )
                ),
            modelName:
                "Dry-solid-conserving wet-basis dryer mass balance",
            limitationDescription:
                "Assumes dry solids are completely retained and only water is removed. Gas-side humidity and energy requirements are excluded."
        )
    }
}
