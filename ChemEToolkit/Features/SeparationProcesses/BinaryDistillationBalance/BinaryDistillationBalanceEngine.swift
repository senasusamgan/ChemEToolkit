struct BinaryDistillationBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            BinaryDistillationBalanceInput
    ) throws
        -> BinaryDistillationBalanceResult {

        let values = [
            input.feedMolarFlow,
            input.feedLightMoleFraction,
            input.distillateLightMoleFraction,
            input.bottomsLightMoleFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinaryDistillationBalanceError
                .nonFiniteInput
        }

        guard input.feedMolarFlow > 0 else {
            throw BinaryDistillationBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.feedLightMoleFraction,
            input.distillateLightMoleFraction,
            input.bottomsLightMoleFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw BinaryDistillationBalanceError
                .fractionOutsideRange
        }

        guard
            input.distillateLightMoleFraction
                > input.feedLightMoleFraction,
            input.feedLightMoleFraction
                > input.bottomsLightMoleFraction
        else {
            throw BinaryDistillationBalanceError
                .invalidSeparationOrdering
        }

        let distillate =
            input.feedMolarFlow
            * (
                input.feedLightMoleFraction
                - input.bottomsLightMoleFraction
            )
            / (
                input.distillateLightMoleFraction
                - input.bottomsLightMoleFraction
            )

        let bottoms =
            input.feedMolarFlow
            - distillate

        let feedLight =
            input.feedMolarFlow
            * input.feedLightMoleFraction

        let distillateLight =
            distillate
            * input.distillateLightMoleFraction

        let bottomsLight =
            bottoms
            * input.bottomsLightMoleFraction

        let recovery =
            distillateLight / feedLight

        let distillateFraction =
            distillate / input.feedMolarFlow

        let outputs = [
            distillate,
            bottoms,
            feedLight,
            distillateLight,
            bottomsLight,
            recovery,
            distillateFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            recovery <= 1 + 1e-12
        else {
            throw BinaryDistillationBalanceError
                .numericalFailure
        }

        return .init(
            distillateMolarFlow:
                distillate,
            bottomsMolarFlow:
                bottoms,
            lightComponentFeedFlow:
                feedLight,
            lightComponentDistillateFlow:
                distillateLight,
            lightComponentBottomsFlow:
                bottomsLight,
            lightRecoveryToDistillate:
                min(1, recovery),
            distillateFractionOfFeed:
                distillateFraction,
            modelName:
                "Binary overall and light-component distillation balance",
            limitationDescription:
                "Assumes steady state, two products and no accumulation, reaction or additional feed and product streams."
        )
    }
}
