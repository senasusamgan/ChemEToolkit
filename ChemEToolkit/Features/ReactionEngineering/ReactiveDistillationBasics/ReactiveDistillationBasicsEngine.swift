struct ReactiveDistillationBasicsEngine:
    Sendable {

    private let wholeNumberTolerance =
        1e-10

    func calculate(
        _ input:
            ReactiveDistillationBasicsInput
    ) throws
        -> ReactiveDistillationBasicsResult {

        let values = [
            input.initialMolesA,
            input.initialMolesB,
            input.equilibriumConstant,
            input.productRemovalFractionPerStage,
            input.numberOfStages
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactiveDistillationBasicsError
                .nonFiniteInput
        }

        guard
            input.initialMolesA > 0,
            input.initialMolesB >= 0
        else {
            throw ReactiveDistillationBasicsError
                .invalidInitialMoles
        }

        guard input.equilibriumConstant > 0 else {
            throw ReactiveDistillationBasicsError
                .nonPositiveEquilibriumConstant
        }

        guard
            input.productRemovalFractionPerStage >= 0,
            input.productRemovalFractionPerStage < 1
        else {
            throw ReactiveDistillationBasicsError
                .removalFractionOutOfRange
        }

        let rounded =
            input.numberOfStages.rounded()

        guard
            abs(
                input.numberOfStages - rounded
            ) <= wholeNumberTolerance,
            rounded >= 1,
            rounded <= 1000
        else {
            throw ReactiveDistillationBasicsError
                .invalidStageCount
        }

        let stages =
            Int(rounded)

        let initialTotal =
            input.initialMolesA
            + input.initialMolesB

        let equilibriumOnlyA =
            initialTotal
            / (
                1
                + input.equilibriumConstant
            )

        let equilibriumOnlyConversion =
            (
                input.initialMolesA
                - equilibriumOnlyA
            )
            / input.initialMolesA

        var molesA =
            input.initialMolesA

        var molesB =
            input.initialMolesB

        var removedB = 0.0

        for _ in 0..<stages {
            let reactiveTotal =
                molesA + molesB

            let equilibriumA =
                reactiveTotal
                / (
                    1
                    + input.equilibriumConstant
                )

            let equilibriumB =
                reactiveTotal
                - equilibriumA

            let stageRemoval =
                input.productRemovalFractionPerStage
                * equilibriumB

            molesA =
                equilibriumA

            molesB =
                equilibriumB
                - stageRemoval

            removedB +=
                stageRemoval
        }

        let conversion =
            (
                input.initialMolesA
                - molesA
            )
            / input.initialMolesA

        let generatedBTotal =
            molesB + removedB

        let productRecovery =
            generatedBTotal > 0
            ? removedB / generatedBTotal
            : 0

        let closure =
            (
                molesA
                + molesB
                + removedB
            )
            / initialTotal

        let enhancement =
            conversion
            - equilibriumOnlyConversion

        let results = [
            molesA,
            molesB,
            removedB,
            conversion,
            equilibriumOnlyConversion,
            enhancement,
            productRecovery,
            closure
        ]

        guard
            results.allSatisfy(\.isFinite),
            molesA >= 0,
            molesB >= 0,
            removedB >= 0,
            productRecovery >= 0,
            productRecovery <= 1,
            abs(closure - 1) < 1e-12
        else {
            throw ReactiveDistillationBasicsError
                .numericalFailure
        }

        return .init(
            numberOfStages:
                stages,
            finalMolesA:
                molesA,
            retainedMolesB:
                molesB,
            removedMolesB:
                removedB,
            conversionOfInitialA:
                conversion,
            equilibriumOnlyConversion:
                equilibriumOnlyConversion,
            conversionEnhancement:
                enhancement,
            productRecoveryFraction:
                productRecovery,
            massBalanceClosure:
                closure,
            modelName:
                "Stagewise equilibrium reaction A ⇌ B with fractional B removal after each stage",
            limitationDescription:
                "A conceptual reactive-distillation model: each stage reaches reaction equilibrium instantly, then removes a fixed fraction of B. Vapor–liquid equilibrium, energy balances, reflux and column hydraulics are not included."
        )
    }
}
