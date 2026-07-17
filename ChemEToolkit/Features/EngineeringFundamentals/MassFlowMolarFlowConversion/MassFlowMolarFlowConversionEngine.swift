struct MassFlowMolarFlowConversionEngine:
    Sendable {

    func calculate(
        _ input:
            MassFlowMolarFlowConversionInput
    ) throws
        -> MassFlowMolarFlowConversionResult {

        let values = [
            input.massFlowRateKilogramsPerHour,
            input
                .molecularWeightKilogramsPerKilomole
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MassFlowMolarFlowConversionError
                .nonFiniteInput
        }

        guard
            input.massFlowRateKilogramsPerHour >= 0
        else {
            throw MassFlowMolarFlowConversionError
                .negativeMassFlow
        }

        guard
            input
                .molecularWeightKilogramsPerKilomole
            > 0
        else {
            throw MassFlowMolarFlowConversionError
                .nonPositiveMolecularWeight
        }

        let kilomolesPerHour =
            input.massFlowRateKilogramsPerHour
            / input
                .molecularWeightKilogramsPerKilomole

        let molesPerSecond =
            kilomolesPerHour
            * 1_000
            / 3_600

        let kilogramsPerSecond =
            input.massFlowRateKilogramsPerHour
            / 3_600

        let backCalculatedMassFlow =
            kilomolesPerHour
            * input
                .molecularWeightKilogramsPerKilomole

        let results = [
            kilomolesPerHour,
            molesPerSecond,
            kilogramsPerSecond,
            backCalculatedMassFlow
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 >= 0 })
        else {
            throw MassFlowMolarFlowConversionError
                .numericalFailure
        }

        return .init(
            molarFlowRateKilomolesPerHour:
                kilomolesPerHour,
            molarFlowRateMolesPerSecond:
                molesPerSecond,
            massFlowRateKilogramsPerSecond:
                kilogramsPerSecond,
            backCalculatedMassFlow:
                backCalculatedMassFlow,
            modelName:
                "Mass-flow divided by molecular weight",
            limitationDescription:
                "Assumes a single component or a mixture represented by one consistent average molecular weight."
        )
    }
}
