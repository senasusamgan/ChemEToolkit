struct CascadeControlEngine: Sendable {
    private let singularTolerance = 1e-12

    func calculate(
        _ input: CascadeControlInput
    ) throws -> CascadeControlResult {

        let values = [
            input.primaryProcessGain,
            input.secondaryProcessGain,
            input.primaryControllerGain,
            input.secondaryControllerGain,
            input.primaryReferenceInput,
            input.secondaryLoopDisturbance
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CascadeControlError.nonFiniteInput
        }

        let innerLoopGain =
            input.secondaryControllerGain
            * input.secondaryProcessGain

        let innerDenominator =
            1 + innerLoopGain

        guard
            abs(innerDenominator)
            > singularTolerance
        else {
            throw CascadeControlError.singularInnerLoop
        }

        let innerClosedGain =
            innerLoopGain
            / innerDenominator

        let innerSensitivity =
            1 / innerDenominator

        let effectiveOuterPlant =
            input.primaryProcessGain
            * innerClosedGain

        let outerLoopGain =
            input.primaryControllerGain
            * effectiveOuterPlant

        let outerDenominator =
            1 + outerLoopGain

        guard
            abs(outerDenominator)
            > singularTolerance
        else {
            throw CascadeControlError.singularOuterLoop
        }

        let outerClosedGain =
            outerLoopGain
            / outerDenominator

        let outerSensitivity =
            1 / outerDenominator

        let outputFromReference =
            outerClosedGain
            * input.primaryReferenceInput

        let outputFromDisturbance =
            input.primaryProcessGain
            * innerSensitivity
            * outerSensitivity
            * input.secondaryLoopDisturbance

        let totalOutput =
            outputFromReference
            + outputFromDisturbance

        let results = [
            innerLoopGain,
            innerClosedGain,
            innerSensitivity,
            effectiveOuterPlant,
            outerLoopGain,
            outerClosedGain,
            outerSensitivity,
            outputFromReference,
            outputFromDisturbance,
            totalOutput
        ]

        guard results.allSatisfy(\.isFinite) else {
            throw CascadeControlError.numericalFailure
        }

        return .init(
            innerLoopGain: innerLoopGain,
            innerClosedLoopGain: innerClosedGain,
            innerSensitivity: innerSensitivity,
            effectiveOuterProcessGain: effectiveOuterPlant,
            outerLoopGain: outerLoopGain,
            outerClosedLoopGain: outerClosedGain,
            outerSensitivity: outerSensitivity,
            outputFromReference: outputFromReference,
            outputFromSecondaryDisturbance: outputFromDisturbance,
            totalPrimaryOutput: totalOutput,
            modelName:
                "Static nested-loop cascade-control reduction",
            limitationDescription:
                "Uses scalar gains only. Real cascade design also requires the secondary loop to be substantially faster than the primary loop and must account for dynamics, delays, limits and controller structure."
        )
    }
}
