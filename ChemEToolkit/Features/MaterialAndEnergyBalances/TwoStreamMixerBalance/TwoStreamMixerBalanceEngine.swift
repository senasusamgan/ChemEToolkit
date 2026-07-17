struct TwoStreamMixerBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            TwoStreamMixerBalanceInput
    ) throws
        -> TwoStreamMixerBalanceResult {

        let values = [
            input.stream1MassFlow,
            input.stream1ComponentMassFraction,
            input.stream2MassFlow,
            input.stream2ComponentMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TwoStreamMixerBalanceError
                .nonFiniteInput
        }

        guard
            input.stream1MassFlow >= 0,
            input.stream2MassFlow >= 0
        else {
            throw TwoStreamMixerBalanceError
                .negativeMassFlow
        }

        let fractions = [
            input.stream1ComponentMassFraction,
            input.stream2ComponentMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw TwoStreamMixerBalanceError
                .fractionOutsideRange
        }

        let outletFlow =
            input.stream1MassFlow
            + input.stream2MassFlow

        guard outletFlow > 0 else {
            throw TwoStreamMixerBalanceError
                .zeroOutletFlow
        }

        let componentFlow1 =
            input.stream1MassFlow
            * input.stream1ComponentMassFraction

        let componentFlow2 =
            input.stream2MassFlow
            * input.stream2ComponentMassFraction

        let outletComponentFlow =
            componentFlow1
            + componentFlow2

        let outletFraction =
            outletComponentFlow
            / outletFlow

        let otherComponentFlow =
            outletFlow
            - outletComponentFlow

        let outputs = [
            outletFlow,
            componentFlow1,
            componentFlow2,
            outletComponentFlow,
            outletFraction,
            otherComponentFlow
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outletFraction >= 0,
            outletFraction <= 1,
            otherComponentFlow >= 0
        else {
            throw TwoStreamMixerBalanceError
                .numericalFailure
        }

        return .init(
            outletMassFlow:
                outletFlow,
            stream1ComponentFlow:
                componentFlow1,
            stream2ComponentFlow:
                componentFlow2,
            outletComponentFlow:
                outletComponentFlow,
            outletComponentMassFraction:
                outletFraction,
            outletOtherComponentFlow:
                otherComponentFlow,
            modelName:
                "Steady two-stream total and component mass balance",
            limitationDescription:
                "Assumes no reaction, accumulation or material loss and requires all flow rates to use the same mass/time unit."
        )
    }
}
