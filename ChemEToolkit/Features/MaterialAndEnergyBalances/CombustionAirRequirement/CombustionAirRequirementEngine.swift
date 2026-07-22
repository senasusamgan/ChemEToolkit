struct CombustionAirRequirementEngine:
    Sendable {

    func calculate(
        _ input:
            CombustionAirRequirementInput
    ) throws
        -> CombustionAirRequirementResult {

        let values = [
            input.fuelMolarFlow,
            input.carbonAtomsPerMolecule,
            input.hydrogenAtomsPerMolecule,
            input.oxygenAtomsPerMolecule,
            input.excessAirFraction,
            input.oxygenMoleFractionInAir
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CombustionAirRequirementError
                .nonFiniteInput
        }

        guard input.fuelMolarFlow >= 0 else {
            throw CombustionAirRequirementError
                .negativeFuelFlow
        }

        let atomCounts = [
            input.carbonAtomsPerMolecule,
            input.hydrogenAtomsPerMolecule,
            input.oxygenAtomsPerMolecule
        ]

        guard
            atomCounts.allSatisfy({
                $0 >= 0
            })
        else {
            throw CombustionAirRequirementError
                .negativeAtomCount
        }

        let oxygenPerMoleFuel =
            input.carbonAtomsPerMolecule
            + input.hydrogenAtomsPerMolecule / 4
            - input.oxygenAtomsPerMolecule / 2

        guard oxygenPerMoleFuel > 0 else {
            throw CombustionAirRequirementError
                .invalidFuelFormula
        }

        guard input.excessAirFraction >= 0 else {
            throw CombustionAirRequirementError
                .negativeExcessAir
        }

        guard
            input.oxygenMoleFractionInAir > 0,
            input.oxygenMoleFractionInAir < 1
        else {
            throw CombustionAirRequirementError
                .invalidOxygenFraction
        }

        let stoichiometricOxygen =
            input.fuelMolarFlow
            * oxygenPerMoleFuel

        let actualOxygen =
            stoichiometricOxygen
            * (
                1
                + input.excessAirFraction
            )

        let theoreticalAir =
            stoichiometricOxygen
            / input.oxygenMoleFractionInAir

        let actualAir =
            actualOxygen
            / input.oxygenMoleFractionInAir

        let nitrogen =
            actualAir
            * (
                1
                - input.oxygenMoleFractionInAir
            )

        let carbonDioxide =
            input.fuelMolarFlow
            * input.carbonAtomsPerMolecule

        let water =
            input.fuelMolarFlow
            * input.hydrogenAtomsPerMolecule
            / 2

        let excessOxygen =
            actualOxygen
            - stoichiometricOxygen

        let dryFlueGas =
            carbonDioxide
            + nitrogen
            + excessOxygen

        let outputs = [
            stoichiometricOxygen,
            actualOxygen,
            theoreticalAir,
            actualAir,
            nitrogen,
            carbonDioxide,
            water,
            excessOxygen,
            dryFlueGas
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 })
        else {
            throw CombustionAirRequirementError
                .numericalFailure
        }

        return .init(
            stoichiometricOxygenFlow:
                stoichiometricOxygen,
            actualOxygenFlow:
                actualOxygen,
            theoreticalAirFlow:
                theoreticalAir,
            actualAirFlow:
                actualAir,
            nitrogenFlow:
                nitrogen,
            carbonDioxideFlow:
                carbonDioxide,
            waterVaporFlow:
                water,
            excessOxygenFlow:
                max(0, excessOxygen),
            dryFlueGasFlow:
                dryFlueGas,
            modelName:
                "Complete-combustion CHO fuel and excess-air balance",
            limitationDescription:
                "Assumes complete combustion to CO₂ and H₂O, air containing only O₂ and inert remainder, and no CO, NOx, dissociation or unburned fuel."
        )
    }
}
