struct CountercurrentSolidsWashingEngine:
    Sendable {

    private let integerTolerance =
        1.0e-9

    private let pivotTolerance =
        1.0e-14

    func calculate(
        _ input:
            CountercurrentSolidsWashingInput
    ) throws
        -> CountercurrentSolidsWashingResult {

        let values = [
            input.insolubleSolidFlowRate,
            input.retainedSolventPerInsolubleSolid,
            input.freshWashSolventFlowRate,
            input.feedUnderflowSoluteRatio,
            input.freshWashSoluteRatio,
            input.numberOfIdealStages
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                CountercurrentSolidsWashingError
                    .nonFiniteInput
        }

        guard
            input.insolubleSolidFlowRate > 0,
            input.retainedSolventPerInsolubleSolid > 0,
            input.freshWashSolventFlowRate > 0
        else {
            throw
                CountercurrentSolidsWashingError
                    .nonPositiveProperty
        }

        guard
            input.feedUnderflowSoluteRatio >= 0,
            input.freshWashSoluteRatio >= 0
        else {
            throw
                CountercurrentSolidsWashingError
                    .negativeSoluteRatio
        }

        let roundedStages =
            input.numberOfIdealStages.rounded()

        guard
            abs(
                input.numberOfIdealStages
                - roundedStages
            ) <= integerTolerance,
            roundedStages >= 1,
            roundedStages <= 100
        else {
            throw
                CountercurrentSolidsWashingError
                    .invalidStageCount
        }

        guard
            input.feedUnderflowSoluteRatio
            > input.freshWashSoluteRatio
        else {
            throw
                CountercurrentSolidsWashingError
                    .noInitialWashingDrivingForce
        }

        let stageCount =
            Int(roundedStages)

        let retainedSolvent =
            input.insolubleSolidFlowRate
            * input.retainedSolventPerInsolubleSolid

        let overflowSolvent =
            input.freshWashSolventFlowRate

        let stageRatios =
            try solveStageRatios(
                stageCount: stageCount,
                retainedSolvent:
                    retainedSolvent,
                overflowSolvent:
                    overflowSolvent,
                feedRatio:
                    input.feedUnderflowSoluteRatio,
                freshWashRatio:
                    input.freshWashSoluteRatio
            )

        guard
            let productOverflowRatio =
                stageRatios.first,
            let finalUnderflowRatio =
                stageRatios.last
        else {
            throw
                CountercurrentSolidsWashingError
                    .numericalFailure
        }

        let initialSolute =
            retainedSolvent
            * input.feedUnderflowSoluteRatio

        let freshWashSolute =
            overflowSolvent
            * input.freshWashSoluteRatio

        let recoveredSolute =
            overflowSolvent
            * productOverflowRatio
            - freshWashSolute

        let residualSolute =
            retainedSolvent
            * finalUnderflowRatio

        let removalFraction =
            initialSolute > 0
            ? recoveredSolute
                / initialSolute
            : 0

        let balanceResidual =
            initialSolute
            + freshWashSolute
            - overflowSolvent
            * productOverflowRatio
            - residualSolute

        let washingFactor =
            overflowSolvent
            / retainedSolvent

        let results = [
            retainedSolvent,
            overflowSolvent,
            washingFactor,
            productOverflowRatio,
            finalUnderflowRatio,
            initialSolute,
            recoveredSolute,
            residualSolute,
            removalFraction,
            balanceResidual
        ] + stageRatios

        guard
            results.allSatisfy(\.isFinite),
            retainedSolvent > 0,
            overflowSolvent > 0,
            washingFactor > 0,
            productOverflowRatio >= 0,
            finalUnderflowRatio >= 0,
            recoveredSolute >= 0,
            residualSolute >= 0,
            removalFraction >= 0,
            removalFraction <= 1
        else {
            throw
                CountercurrentSolidsWashingError
                    .numericalFailure
        }

        return
            CountercurrentSolidsWashingResult(
                numberOfIdealStages:
                    stageCount,
                retainedSolventFlowRate:
                    retainedSolvent,
                overflowSolventFlowRate:
                    overflowSolvent,
                washingFactor:
                    washingFactor,
                productOverflowSoluteRatio:
                    productOverflowRatio,
                finalUnderflowSoluteRatio:
                    finalUnderflowRatio,
                initialSoluteWithUnderflow:
                    initialSolute,
                recoveredSoluteInOverflow:
                    recoveredSolute,
                residualSoluteWithWashedSolids:
                    residualSolute,
                soluteRemovalFraction:
                    removalFraction,
                soluteBalanceResidual:
                    balanceResidual,
                stageSoluteRatios:
                    stageRatios,
                modelName:
                    "Ideal countercurrent solids washing with constant solute-free solvent flows",
                limitationDescription:
                    "Each stage is perfectly mixed, overflow and retained underflow solution leave each stage at the same solute ratio, and solvent retained by the insoluble solids is constant."
            )
    }

    private func solveStageRatios(
        stageCount: Int,
        retainedSolvent: Double,
        overflowSolvent: Double,
        feedRatio: Double,
        freshWashRatio: Double
    ) throws -> [Double] {
        let lower =
            Array(
                repeating: -retainedSolvent,
                count: max(0, stageCount - 1)
            )

        var diagonal =
            Array(
                repeating:
                    retainedSolvent
                    + overflowSolvent,
                count: stageCount
            )

        let upper =
            Array(
                repeating: -overflowSolvent,
                count: max(0, stageCount - 1)
            )

        var rightHandSide =
            Array(
                repeating: 0.0,
                count: stageCount
            )

        rightHandSide[0] =
            retainedSolvent
            * feedRatio

        rightHandSide[stageCount - 1] +=
            overflowSolvent
            * freshWashRatio

        if stageCount == 1 {
            guard
                abs(diagonal[0])
                > pivotTolerance
            else {
                throw
                    CountercurrentSolidsWashingError
                        .singularStageSystem
            }

            return [
                rightHandSide[0]
                / diagonal[0]
            ]
        }

        for index in 1..<stageCount {
            guard
                abs(diagonal[index - 1])
                > pivotTolerance
            else {
                throw
                    CountercurrentSolidsWashingError
                        .singularStageSystem
            }

            let multiplier =
                lower[index - 1]
                / diagonal[index - 1]

            diagonal[index] -=
                multiplier
                * upper[index - 1]

            rightHandSide[index] -=
                multiplier
                * rightHandSide[index - 1]
        }

        guard
            abs(diagonal[stageCount - 1])
            > pivotTolerance
        else {
            throw
                CountercurrentSolidsWashingError
                    .singularStageSystem
        }

        var solution =
            Array(
                repeating: 0.0,
                count: stageCount
            )

        solution[stageCount - 1] =
            rightHandSide[stageCount - 1]
            / diagonal[stageCount - 1]

        if stageCount >= 2 {
            for index in stride(
                from: stageCount - 2,
                through: 0,
                by: -1
            ) {
                guard
                    abs(diagonal[index])
                    > pivotTolerance
                else {
                    throw
                        CountercurrentSolidsWashingError
                            .singularStageSystem
                }

                solution[index] =
                    (
                        rightHandSide[index]
                        - upper[index]
                        * solution[index + 1]
                    )
                    / diagonal[index]
            }
        }

        return solution
    }
}
