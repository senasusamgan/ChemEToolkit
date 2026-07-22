struct MassMoleConversionEngine:
    Sendable {

    func calculate(
        _ input:
            MassMoleConversionInput
    ) throws
        -> MassMoleConversionResult {

        let values = [
            input.massKilograms,
            input
                .molecularWeightKilogramsPerKilomole
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MassMoleConversionError
                .nonFiniteInput
        }

        guard input.massKilograms >= 0 else {
            throw MassMoleConversionError
                .negativeMass
        }

        guard
            input
                .molecularWeightKilogramsPerKilomole
            > 0
        else {
            throw MassMoleConversionError
                .nonPositiveMolecularWeight
        }

        let kilomoles =
            input.massKilograms
            / input
                .molecularWeightKilogramsPerKilomole

        let moles =
            kilomoles
            * 1_000

        let millimoles =
            moles
            * 1_000

        let backCalculatedMass =
            kilomoles
            * input
                .molecularWeightKilogramsPerKilomole

        let results = [
            kilomoles,
            moles,
            millimoles,
            backCalculatedMass
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 >= 0 })
        else {
            throw MassMoleConversionError
                .numericalFailure
        }

        return .init(
            amountKilomoles:
                kilomoles,
            amountMoles:
                moles,
            amountMillimoles:
                millimoles,
            backCalculatedMassKilograms:
                backCalculatedMass,
            modelName:
                "Mass divided by molecular weight",
            limitationDescription:
                "Use molecular weight in kg/kmol, numerically equivalent to g/mol."
        )
    }
}
