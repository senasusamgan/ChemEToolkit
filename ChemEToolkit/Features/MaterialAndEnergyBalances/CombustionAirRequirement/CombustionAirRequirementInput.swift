struct CombustionAirRequirementInput:
    Equatable,
    Sendable {

    let fuelMolarFlow: Double
    let carbonAtomsPerMolecule:
        Double
    let hydrogenAtomsPerMolecule:
        Double
    let oxygenAtomsPerMolecule:
        Double
    let excessAirFraction:
        Double
    let oxygenMoleFractionInAir:
        Double
}
