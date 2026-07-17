struct FilterCakeBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            FilterCakeBalanceInput
    ) throws
        -> FilterCakeBalanceResult {

        let values = [
            input.slurryFeedMassFlow,
            input.feedDrySolidMassFraction,
            input.cakeLiquidMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FilterCakeBalanceError
                .nonFiniteInput
        }

        guard input.slurryFeedMassFlow > 0 else {
            throw FilterCakeBalanceError
                .nonPositiveFeedFlow
        }

        guard
            input.feedDrySolidMassFraction >= 0,
            input.feedDrySolidMassFraction <= 1
        else {
            throw FilterCakeBalanceError
                .invalidFeedSolidsFraction
        }

        guard
            input.cakeLiquidMassFraction >= 0,
            input.cakeLiquidMassFraction < 1
        else {
            throw FilterCakeBalanceError
                .invalidCakeLiquidFraction
        }

        let drySolids =
            input.slurryFeedMassFlow
            * input.feedDrySolidMassFraction

        let feedLiquid =
            input.slurryFeedMassFlow
            - drySolids

        let wetCake =
            drySolids
            / (
                1
                - input.cakeLiquidMassFraction
            )

        let cakeLiquid =
            wetCake
            - drySolids

        let filtrateLiquid =
            feedLiquid
            - cakeLiquid

        let tolerance =
            max(
                1e-12,
                input.slurryFeedMassFlow
                * 1e-12
            )

        guard filtrateLiquid >= -tolerance else {
            throw FilterCakeBalanceError
                .infeasibleCakeMoisture
        }

        let cakeSolidFraction =
            wetCake > 0
            ? drySolids / wetCake
            : 0

        let liquidRecovery =
            feedLiquid > 0
            ? max(0, filtrateLiquid)
                / feedLiquid
            : 0

        let outputs = [
            drySolids,
            feedLiquid,
            wetCake,
            cakeLiquid,
            filtrateLiquid,
            cakeSolidFraction,
            liquidRecovery
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            drySolids >= 0,
            feedLiquid >= 0,
            wetCake >= 0,
            cakeLiquid >= 0,
            cakeSolidFraction >= 0,
            cakeSolidFraction <= 1,
            liquidRecovery >= 0,
            liquidRecovery <= 1 + 1e-12
        else {
            throw FilterCakeBalanceError
                .numericalFailure
        }

        return .init(
            drySolidFlow:
                drySolids,
            feedLiquidFlow:
                feedLiquid,
            wetCakeMassFlow:
                wetCake,
            cakeLiquidFlow:
                cakeLiquid,
            filtrateLiquidFlow:
                max(0, filtrateLiquid),
            cakeDrySolidMassFraction:
                cakeSolidFraction,
            liquidRecoveryToFiltrate:
                min(1, liquidRecovery),
            modelName:
                "Dry-solid-conserving filtration balance",
            limitationDescription:
                "Assumes all dry solids report to the cake, the filtrate is solids-free and cake moisture is expressed on a wet mass basis."
        )
    }
}
