struct PhaseChangeEnergyBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            PhaseChangeEnergyBalanceInput
    ) throws
        -> PhaseChangeEnergyBalanceResult {

        let values = [
            input.massFlowRate,
            input.latentHeat,
            input.phaseChangeFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PhaseChangeEnergyBalanceError
                .nonFiniteInput
        }

        guard input.massFlowRate >= 0 else {
            throw PhaseChangeEnergyBalanceError
                .negativeMassFlow
        }

        guard input.latentHeat > 0 else {
            throw PhaseChangeEnergyBalanceError
                .nonPositiveLatentHeat
        }

        guard
            input.phaseChangeFraction >= 0,
            input.phaseChangeFraction <= 1
        else {
            throw PhaseChangeEnergyBalanceError
                .fractionOutsideRange
        }

        let transformed =
            input.massFlowRate
            * input.phaseChangeFraction

        let untransformed =
            input.massFlowRate
            - transformed

        let duty =
            transformed
            * input.latentHeat

        let specificDuty =
            input.massFlowRate > 0
            ? duty / input.massFlowRate
            : 0

        let outputs = [
            transformed,
            untransformed,
            duty,
            specificDuty
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 })
        else {
            throw PhaseChangeEnergyBalanceError
                .numericalFailure
        }

        return .init(
            transformedMassFlow:
                transformed,
            untransformedMassFlow:
                untransformed,
            heatDuty:
                duty,
            specificDutyOnFeedBasis:
                specificDuty,
            modelName:
                "Latent-heat phase-change energy balance",
            limitationDescription:
                "Uses Q̇ = ṁfλ and excludes sensible heating or cooling before and after the phase transition."
        )
    }
}
