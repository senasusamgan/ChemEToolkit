struct BypassMixingBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            BypassMixingBalanceInput
    ) throws
        -> BypassMixingBalanceResult {

        let values = [
            input.feedMassFlow,
            input.feedComponentMassFraction,
            input.bypassFraction,
            input.processedStreamComponentMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BypassMixingBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow > 0 else {
            throw BypassMixingBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.feedComponentMassFraction,
            input.bypassFraction,
            input.processedStreamComponentMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw BypassMixingBalanceError
                .fractionOutsideRange
        }

        let bypassFlow =
            input.feedMassFlow
            * input.bypassFraction

        let processedFlow =
            input.feedMassFlow
            - bypassFlow

        let bypassComponent =
            bypassFlow
            * input.feedComponentMassFraction

        let processedComponent =
            processedFlow
            * input
                .processedStreamComponentMassFraction

        let mixedFlow =
            bypassFlow
            + processedFlow

        let mixedComponent =
            bypassComponent
            + processedComponent

        let mixedFraction =
            mixedComponent
            / mixedFlow

        let outputs = [
            bypassFlow,
            processedFlow,
            bypassComponent,
            processedComponent,
            mixedFlow,
            mixedComponent,
            mixedFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 }),
            mixedFraction <= 1
        else {
            throw BypassMixingBalanceError
                .numericalFailure
        }

        return .init(
            bypassMassFlow:
                bypassFlow,
            processedBranchMassFlow:
                processedFlow,
            bypassComponentFlow:
                bypassComponent,
            processedComponentFlow:
                processedComponent,
            mixedOutletMassFlow:
                mixedFlow,
            mixedOutletComponentFlow:
                mixedComponent,
            mixedOutletComponentMassFraction:
                mixedFraction,
            modelName:
                "Bypass split, process and remix component balance",
            limitationDescription:
                "Assumes the processed branch retains its total mass flow while its component fraction changes to the entered value."
        )
    }
}
