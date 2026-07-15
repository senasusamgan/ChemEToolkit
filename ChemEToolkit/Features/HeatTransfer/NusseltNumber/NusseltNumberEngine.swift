import Foundation

struct NusseltNumberEngine {

    func calculate(
        input: NusseltNumberInput
    ) throws -> NusseltNumberResult {

        try validate(input)

        let referenceConductionCoefficient =
            input.fluidThermalConductivity
            / input.characteristicLength

        let nusseltNumber =
            input.heatTransferCoefficient
            / referenceConductionCoefficient

        return NusseltNumberResult(
            nusseltNumber: nusseltNumber,
            referenceConductionCoefficient:
                referenceConductionCoefficient,
            transportRegime:
                regime(for: nusseltNumber)
        )
    }

    private func regime(
        for nusseltNumber: Double
    ) -> NusseltTransportRegime {

        let tolerance = 1e-9

        if abs(nusseltNumber - 1)
            <= tolerance {
            return .approximatelyUnity
        }

        if nusseltNumber < 1 {
            return .belowUnity
        }

        return .convectionEnhanced
    }

    private func validate(
        _ input: NusseltNumberInput
    ) throws {

        let values = [
            input.heatTransferCoefficient,
            input.characteristicLength,
            input.fluidThermalConductivity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw NusseltNumberError.nonFiniteInput
        }

        guard input.heatTransferCoefficient > 0 else {
            throw NusseltNumberError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.characteristicLength > 0 else {
            throw NusseltNumberError
                .nonPositiveCharacteristicLength
        }

        guard input.fluidThermalConductivity > 0 else {
            throw NusseltNumberError
                .nonPositiveThermalConductivity
        }
    }
}
