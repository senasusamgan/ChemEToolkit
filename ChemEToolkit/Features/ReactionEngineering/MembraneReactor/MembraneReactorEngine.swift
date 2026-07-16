struct MembraneReactorEngine:
    Sendable {

    private let integrationSteps =
        20_000

    private struct State {
        var concentrationA: Double
        var concentrationB: Double
        var removedB: Double
    }

    func calculate(
        _ input:
            MembraneReactorInput
    ) throws
        -> MembraneReactorResult {

        let values = [
            input.inletConcentrationA,
            input.inletConcentrationB,
            input.forwardRateConstant,
            input.reverseRateConstant,
            input.membraneRemovalConstant,
            input.spaceTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MembraneReactorError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.inletConcentrationB >= 0
        else {
            throw MembraneReactorError
                .invalidFeedConcentration
        }

        guard
            input.forwardRateConstant > 0,
            input.reverseRateConstant >= 0,
            input.membraneRemovalConstant >= 0
        else {
            throw MembraneReactorError
                .invalidRateConstant
        }

        guard input.spaceTime > 0 else {
            throw MembraneReactorError
                .nonPositiveSpaceTime
        }

        func integrate(
            membraneConstant: Double
        ) throws -> State {

            func derivatives(
                _ state: State
            ) -> State {
                let forward =
                    input.forwardRateConstant
                    * state.concentrationA

                let reverse =
                    input.reverseRateConstant
                    * state.concentrationB

                let removal =
                    membraneConstant
                    * state.concentrationB

                return .init(
                    concentrationA:
                        -forward + reverse,
                    concentrationB:
                        forward
                        - reverse
                        - removal,
                    removedB:
                        removal
                )
            }

            var state =
                State(
                    concentrationA:
                        input.inletConcentrationA,
                    concentrationB:
                        input.inletConcentrationB,
                    removedB: 0
                )

            let step =
                input.spaceTime
                / Double(integrationSteps)

            for _ in 0..<integrationSteps {
                let k1 = derivatives(state)

                let s2 = State(
                    concentrationA:
                        state.concentrationA
                        + 0.5
                        * step
                        * k1.concentrationA,
                    concentrationB:
                        state.concentrationB
                        + 0.5
                        * step
                        * k1.concentrationB,
                    removedB:
                        state.removedB
                        + 0.5
                        * step
                        * k1.removedB
                )

                let k2 = derivatives(s2)

                let s3 = State(
                    concentrationA:
                        state.concentrationA
                        + 0.5
                        * step
                        * k2.concentrationA,
                    concentrationB:
                        state.concentrationB
                        + 0.5
                        * step
                        * k2.concentrationB,
                    removedB:
                        state.removedB
                        + 0.5
                        * step
                        * k2.removedB
                )

                let k3 = derivatives(s3)

                let s4 = State(
                    concentrationA:
                        state.concentrationA
                        + step
                        * k3.concentrationA,
                    concentrationB:
                        state.concentrationB
                        + step
                        * k3.concentrationB,
                    removedB:
                        state.removedB
                        + step
                        * k3.removedB
                )

                let k4 = derivatives(s4)

                state.concentrationA +=
                    step / 6
                    * (
                        k1.concentrationA
                        + 2 * k2.concentrationA
                        + 2 * k3.concentrationA
                        + k4.concentrationA
                    )

                state.concentrationB +=
                    step / 6
                    * (
                        k1.concentrationB
                        + 2 * k2.concentrationB
                        + 2 * k3.concentrationB
                        + k4.concentrationB
                    )

                state.removedB +=
                    step / 6
                    * (
                        k1.removedB
                        + 2 * k2.removedB
                        + 2 * k3.removedB
                        + k4.removedB
                    )

                guard
                    state.concentrationA.isFinite,
                    state.concentrationB.isFinite,
                    state.removedB.isFinite,
                    state.concentrationA >= -1e-9,
                    state.concentrationB >= -1e-9,
                    state.removedB >= -1e-9
                else {
                    throw MembraneReactorError
                        .numericalFailure
                }

                state.concentrationA =
                    max(
                        0,
                        state.concentrationA
                    )

                state.concentrationB =
                    max(
                        0,
                        state.concentrationB
                    )

                state.removedB =
                    max(
                        0,
                        state.removedB
                    )
            }

            return state
        }

        let membraneState =
            try integrate(
                membraneConstant:
                    input.membraneRemovalConstant
            )

        let referenceState =
            try integrate(
                membraneConstant: 0
            )

        let conversion =
            (
                input.inletConcentrationA
                - membraneState.concentrationA
            )
            / input.inletConcentrationA

        let referenceConversion =
            (
                input.inletConcentrationA
                - referenceState.concentrationA
            )
            / input.inletConcentrationA

        let generatedAndPresentB =
            membraneState.concentrationB
            + membraneState.removedB

        let removalFraction =
            generatedAndPresentB > 0
            ? membraneState.removedB
                / generatedAndPresentB
            : 0

        let totalIn =
            input.inletConcentrationA
            + input.inletConcentrationB

        let totalOut =
            membraneState.concentrationA
            + membraneState.concentrationB
            + membraneState.removedB

        let closure =
            totalOut / totalIn

        let gain =
            conversion - referenceConversion

        let results = [
            membraneState.concentrationA,
            membraneState.concentrationB,
            membraneState.removedB,
            conversion,
            removalFraction,
            referenceConversion,
            gain,
            closure
        ]

        guard
            results.allSatisfy(\.isFinite),
            membraneState.concentrationA >= 0,
            membraneState.concentrationB >= 0,
            membraneState.removedB >= 0,
            removalFraction >= 0,
            removalFraction <= 1,
            abs(closure - 1) < 1e-7
        else {
            throw MembraneReactorError
                .numericalFailure
        }

        return .init(
            outletConcentrationA:
                membraneState.concentrationA,
            outletConcentrationB:
                membraneState.concentrationB,
            removedProductEquivalent:
                membraneState.removedB,
            conversionOfA:
                conversion,
            productRemovalFraction:
                removalFraction,
            conversionWithoutMembrane:
                referenceConversion,
            membraneConversionGain:
                gain,
            massBalanceClosure:
                closure,
            modelName:
                "Isothermal plug-flow membrane reactor for reversible first-order A ⇌ B with selective B removal",
            limitationDescription:
                "Uses uniform first-order membrane removal and constant density. Pressure effects, membrane area variation, concentration polarization and transport resistances are not modeled."
        )
    }
}
