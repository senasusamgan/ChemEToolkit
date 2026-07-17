struct MembraneSeparatorBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            MembraneSeparatorBalanceInput
    ) throws
        -> MembraneSeparatorBalanceResult {

        let values = [
            input.feedMassFlow,
            input.feedComponentMassFraction,
            input.stageCutFraction,
            input.observedRejectionFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MembraneSeparatorBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow > 0 else {
            throw MembraneSeparatorBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.feedComponentMassFraction,
            input.observedRejectionFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw MembraneSeparatorBalanceError
                .fractionOutsideRange
        }

        guard
            input.stageCutFraction >= 0,
            input.stageCutFraction < 1
        else {
            throw MembraneSeparatorBalanceError
                .invalidStageCut
        }

        let permeateFlow =
            input.feedMassFlow
            * input.stageCutFraction

        let retentateFlow =
            input.feedMassFlow
            - permeateFlow

        let permeateFraction =
            input.feedComponentMassFraction
            * (
                1
                - input.observedRejectionFraction
            )

        let feedComponent =
            input.feedMassFlow
            * input.feedComponentMassFraction

        let permeateComponent =
            permeateFlow
            * permeateFraction

        let retentateComponent =
            feedComponent
            - permeateComponent

        let retentateFraction =
            retentateComponent
            / retentateFlow

        guard
            retentateFraction >= -1e-12,
            retentateFraction <= 1 + 1e-12
        else {
            throw MembraneSeparatorBalanceError
                .infeasibleRetentateComposition
        }

        let recovery =
            feedComponent > 0
            ? retentateComponent
                / feedComponent
            : 0

        let outputs = [
            permeateFlow,
            retentateFlow,
            permeateFraction,
            retentateFraction,
            feedComponent,
            permeateComponent,
            retentateComponent,
            recovery
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            recovery <= 1 + 1e-12
        else {
            throw MembraneSeparatorBalanceError
                .numericalFailure
        }

        return .init(
            permeateMassFlow:
                permeateFlow,
            retentateMassFlow:
                retentateFlow,
            permeateComponentMassFraction:
                permeateFraction,
            retentateComponentMassFraction:
                min(1, max(0, retentateFraction)),
            feedComponentFlow:
                feedComponent,
            permeateComponentFlow:
                permeateComponent,
            retentateComponentFlow:
                retentateComponent,
            componentRecoveryToRetentate:
                min(1, max(0, recovery)),
            modelName:
                "Stage-cut membrane balance using observed rejection",
            limitationDescription:
                "Uses permeate concentration equal to feed concentration multiplied by one minus rejection. Concentration polarization, pressure dependence and changing local feed composition are excluded."
        )
    }
}
