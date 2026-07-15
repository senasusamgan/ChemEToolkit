struct EquimolarCounterDiffusionEngine: Sendable {
    private let gasConstant = 8.314462618

    func calculate(_ input: EquimolarCounterDiffusionInput) throws -> EquimolarCounterDiffusionResult {
        let values = [
            input.diffusivity,
            input.totalPressure,
            input.temperature,
            input.thickness,
            input.moleFractionAAtSideOne,
            input.moleFractionAAtSideTwo
        ]
        guard values.allSatisfy(\.isFinite) else {
            throw EquimolarCounterDiffusionError.nonFiniteInput
        }
        guard input.diffusivity > 0,
              input.totalPressure > 0,
              input.temperature > 0,
              input.thickness > 0 else {
            throw EquimolarCounterDiffusionError.nonPositiveProperty
        }
        guard (0...1).contains(input.moleFractionAAtSideOne),
              (0...1).contains(input.moleFractionAAtSideTwo) else {
            throw EquimolarCounterDiffusionError.invalidMoleFraction
        }

        let concentration = input.totalPressure / (gasConstant * input.temperature)
        let fluxA = input.diffusivity
            * concentration
            * (input.moleFractionAAtSideOne - input.moleFractionAAtSideTwo)
            / input.thickness

        return EquimolarCounterDiffusionResult(
            fluxA: fluxA,
            fluxB: -fluxA,
            totalMolarFlux: 0,
            totalMolarConcentration: concentration
        )
    }
}
