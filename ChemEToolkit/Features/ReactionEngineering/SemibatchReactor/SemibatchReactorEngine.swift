struct SemibatchReactorEngine:
    Sendable {

    private let integrationSteps =
        20_000

    func calculate(
        _ input:
            SemibatchReactorInput
    ) throws
        -> SemibatchReactorResult {

        let values = [
            input.initialLiquidVolume,
            input.initialMolesB,
            input.feedConcentrationA,
            input.feedVolumetricFlowRate,
            input.secondOrderRateConstant,
            input.operationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SemibatchReactorError
                .nonFiniteInput
        }

        guard input.initialLiquidVolume > 0 else {
            throw SemibatchReactorError
                .nonPositiveInitialVolume
        }

        guard input.initialMolesB > 0 else {
            throw SemibatchReactorError
                .nonPositiveInitialMolesB
        }

        guard
            input.feedConcentrationA > 0,
            input.feedVolumetricFlowRate > 0
        else {
            throw SemibatchReactorError
                .nonPositiveFeedCondition
        }

        guard input.secondOrderRateConstant > 0 else {
            throw SemibatchReactorError
                .nonPositiveRateConstant
        }

        guard input.operationTime > 0 else {
            throw SemibatchReactorError
                .nonPositiveOperationTime
        }

        struct State {
            var molesA: Double
            var molesB: Double
            var productMoles: Double
        }

        func derivatives(
            time: Double,
            state: State
        ) -> State {
            let volume =
                input.initialLiquidVolume
                + input.feedVolumetricFlowRate
                * time

            let reactionMolarRate =
                input.secondOrderRateConstant
                * state.molesA
                * state.molesB
                / volume

            return .init(
                molesA:
                    input.feedVolumetricFlowRate
                    * input.feedConcentrationA
                    - reactionMolarRate,
                molesB:
                    -reactionMolarRate,
                productMoles:
                    reactionMolarRate
            )
        }

        let timeStep =
            input.operationTime
            / Double(integrationSteps)

        var state =
            State(
                molesA: 0,
                molesB:
                    input.initialMolesB,
                productMoles: 0
            )

        var time = 0.0
        var maximumRate = 0.0
        var timeAtMaximumRate = 0.0

        for _ in 0..<integrationSteps {
            let kOne =
                derivatives(
                    time: time,
                    state: state
                )

            let stateTwo =
                State(
                    molesA:
                        state.molesA
                        + 0.5
                        * timeStep
                        * kOne.molesA,
                    molesB:
                        state.molesB
                        + 0.5
                        * timeStep
                        * kOne.molesB,
                    productMoles:
                        state.productMoles
                        + 0.5
                        * timeStep
                        * kOne.productMoles
                )

            let kTwo =
                derivatives(
                    time:
                        time
                        + 0.5
                        * timeStep,
                    state: stateTwo
                )

            let stateThree =
                State(
                    molesA:
                        state.molesA
                        + 0.5
                        * timeStep
                        * kTwo.molesA,
                    molesB:
                        state.molesB
                        + 0.5
                        * timeStep
                        * kTwo.molesB,
                    productMoles:
                        state.productMoles
                        + 0.5
                        * timeStep
                        * kTwo.productMoles
                )

            let kThree =
                derivatives(
                    time:
                        time
                        + 0.5
                        * timeStep,
                    state: stateThree
                )

            let stateFour =
                State(
                    molesA:
                        state.molesA
                        + timeStep
                        * kThree.molesA,
                    molesB:
                        state.molesB
                        + timeStep
                        * kThree.molesB,
                    productMoles:
                        state.productMoles
                        + timeStep
                        * kThree.productMoles
                )

            let kFour =
                derivatives(
                    time:
                        time
                        + timeStep,
                    state: stateFour
                )

            state.molesA +=
                timeStep
                / 6
                * (
                    kOne.molesA
                    + 2 * kTwo.molesA
                    + 2 * kThree.molesA
                    + kFour.molesA
                )

            state.molesB +=
                timeStep
                / 6
                * (
                    kOne.molesB
                    + 2 * kTwo.molesB
                    + 2 * kThree.molesB
                    + kFour.molesB
                )

            state.productMoles +=
                timeStep
                / 6
                * (
                    kOne.productMoles
                    + 2 * kTwo.productMoles
                    + 2 * kThree.productMoles
                    + kFour.productMoles
                )

            time += timeStep

            let currentVolume =
                input.initialLiquidVolume
                + input.feedVolumetricFlowRate
                * time

            let currentRate =
                input.secondOrderRateConstant
                * max(0, state.molesA)
                * max(0, state.molesB)
                / currentVolume

            if currentRate > maximumRate {
                maximumRate = currentRate
                timeAtMaximumRate = time
            }

            guard
                state.molesA.isFinite,
                state.molesB.isFinite,
                state.productMoles.isFinite,
                state.molesA >= -1.0e-9,
                state.molesB >= -1.0e-9,
                state.productMoles >= -1.0e-9
            else {
                throw SemibatchReactorError
                    .numericalFailure
            }

            state.molesA =
                max(0, state.molesA)
            state.molesB =
                max(0, state.molesB)
            state.productMoles =
                max(0, state.productMoles)
        }

        let finalVolume =
            input.initialLiquidVolume
            + input.feedVolumetricFlowRate
            * input.operationTime

        let totalAFed =
            input.feedConcentrationA
            * input.feedVolumetricFlowRate
            * input.operationTime

        let reactedA =
            max(
                0,
                totalAFed
                - state.molesA
            )

        let conversionA =
            totalAFed > 0
            ? reactedA / totalAFed
            : 0

        let conversionB =
            (
                input.initialMolesB
                - state.molesB
            )
            / input.initialMolesB

        let concentrationA =
            state.molesA / finalVolume

        let concentrationB =
            state.molesB / finalVolume

        let productConcentration =
            state.productMoles
            / finalVolume

        let results = [
            finalVolume,
            totalAFed,
            state.molesA,
            state.molesB,
            state.productMoles,
            concentrationA,
            concentrationB,
            productConcentration,
            conversionA,
            conversionB,
            maximumRate,
            timeAtMaximumRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            finalVolume > 0,
            totalAFed > 0,
            state.molesA >= 0,
            state.molesB >= 0,
            state.productMoles >= 0,
            concentrationA >= 0,
            concentrationB >= 0,
            productConcentration >= 0,
            conversionA >= 0,
            conversionA <= 1.000001,
            conversionB >= 0,
            conversionB <= 1.000001,
            maximumRate >= 0,
            timeAtMaximumRate >= 0
        else {
            throw SemibatchReactorError
                .numericalFailure
        }

        return .init(
            finalLiquidVolume:
                finalVolume,
            totalMolesAFed:
                totalAFed,
            finalMolesA:
                state.molesA,
            finalMolesB:
                state.molesB,
            productMoles:
                state.productMoles,
            finalConcentrationA:
                concentrationA,
            finalConcentrationB:
                concentrationB,
            finalProductConcentration:
                productConcentration,
            conversionOfFedA:
                min(1, conversionA),
            conversionOfInitialB:
                min(1, conversionB),
            maximumReactionRate:
                maximumRate,
            timeAtMaximumReactionRate:
                timeAtMaximumRate,
            modelName:
                "Variable-volume semibatch reactor with A feed and second-order reaction A + B → P",
            limitationDescription:
                "Solves molar balances by 20,000-step RK4 integration. Assumes perfect mixing, constant temperature, constant feed concentration and flow, no outlet stream and constant liquid density."
        )
    }
}
