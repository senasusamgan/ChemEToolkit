import Foundation

struct BiotNumberEngine {

    func calculate(
        input: BiotNumberInput
    ) throws -> BiotNumberResult {

        try validate(input)

        let internalConductionScale =
            input.solidThermalConductivity
            / input.characteristicLength

        let biotNumber =
            input.heatTransferCoefficient
            / internalConductionScale

        return BiotNumberResult(
            biotNumber: biotNumber,
            internalConductionScale:
                internalConductionScale,
            externalConvectionCoefficient:
                input.heatTransferCoefficient,
            lumpedCapacitanceUsuallyValid:
                biotNumber < 0.1
        )
    }

    private func validate(
        _ input: BiotNumberInput
    ) throws {

        let values = [
            input.heatTransferCoefficient,
            input.characteristicLength,
            input.solidThermalConductivity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BiotNumberError.nonFiniteInput
        }

        guard input.heatTransferCoefficient > 0 else {
            throw BiotNumberError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.characteristicLength > 0 else {
            throw BiotNumberError
                .nonPositiveCharacteristicLength
        }

        guard input.solidThermalConductivity > 0 else {
            throw BiotNumberError
                .nonPositiveSolidThermalConductivity
        }
    }
}
