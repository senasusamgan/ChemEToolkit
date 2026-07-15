import Foundation

struct PrandtlNumberEngine {

    func calculate(
        input: PrandtlNumberInput
    ) throws -> PrandtlNumberResult {

        try validate(input)

        let prandtlNumber =
            input.dynamicViscosity
            * input.specificHeatCapacity
            / input.thermalConductivity

        return PrandtlNumberResult(
            prandtlNumber: prandtlNumber,
            transportRegime:
                regime(for: prandtlNumber)
        )
    }

    private func regime(
        for prandtlNumber: Double
    ) -> PrandtlTransportRegime {

        if prandtlNumber < 0.1 {
            return .thermalDiffusionDominant
        }

        if prandtlNumber > 10 {
            return .momentumDiffusionDominant
        }

        return .comparableDiffusion
    }

    private func validate(
        _ input: PrandtlNumberInput
    ) throws {

        let values = [
            input.dynamicViscosity,
            input.specificHeatCapacity,
            input.thermalConductivity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PrandtlNumberError.nonFiniteInput
        }

        guard input.dynamicViscosity > 0 else {
            throw PrandtlNumberError
                .nonPositiveDynamicViscosity
        }

        guard input.specificHeatCapacity > 0 else {
            throw PrandtlNumberError
                .nonPositiveSpecificHeatCapacity
        }

        guard input.thermalConductivity > 0 else {
            throw PrandtlNumberError
                .nonPositiveThermalConductivity
        }
    }
}
