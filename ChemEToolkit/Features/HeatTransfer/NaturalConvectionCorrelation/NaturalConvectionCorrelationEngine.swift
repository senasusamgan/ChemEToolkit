import Foundation

struct NaturalConvectionCorrelationEngine {

    func calculate(
        input: NaturalConvectionCorrelationInput
    ) throws -> NaturalConvectionCorrelationResult {

        try validate(input)

        let nusseltNumber: Double
        let correlation:
            NaturalConvectionCorrelationUsed

        switch input.geometry {
        case .verticalPlate:
            let denominator =
                pow(
                    1
                    + pow(
                        0.492
                        / input.prandtlNumber,
                        9.0 / 16.0
                    ),
                    8.0 / 27.0
                )

            nusseltNumber =
                pow(
                    0.825
                    + 0.387
                    * pow(
                        input.rayleighNumber,
                        1.0 / 6.0
                    )
                    / denominator,
                    2
                )

            correlation =
                .churchillChuVerticalPlate

        case .horizontalCylinder:
            let denominator =
                pow(
                    1
                    + pow(
                        0.559
                        / input.prandtlNumber,
                        9.0 / 16.0
                    ),
                    8.0 / 27.0
                )

            nusseltNumber =
                pow(
                    0.60
                    + 0.387
                    * pow(
                        input.rayleighNumber,
                        1.0 / 6.0
                    )
                    / denominator,
                    2
                )

            correlation =
                .churchillChuHorizontalCylinder
        }

        return NaturalConvectionCorrelationResult(
            nusseltNumber: nusseltNumber,
            heatTransferCoefficient:
                nusseltNumber
                * input.fluidThermalConductivity
                / input.characteristicLength,
            correlationUsed: correlation
        )
    }

    private func validate(
        _ input: NaturalConvectionCorrelationInput
    ) throws {
        let values = [
            input.rayleighNumber,
            input.prandtlNumber,
            input.fluidThermalConductivity,
            input.characteristicLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw NaturalConvectionCorrelationError
                .nonFiniteInput
        }

        guard input.rayleighNumber > 0 else {
            throw NaturalConvectionCorrelationError
                .nonPositiveRayleighNumber
        }

        guard input.prandtlNumber > 0 else {
            throw NaturalConvectionCorrelationError
                .nonPositivePrandtlNumber
        }

        guard input.fluidThermalConductivity > 0 else {
            throw NaturalConvectionCorrelationError
                .nonPositiveThermalConductivity
        }

        guard input.characteristicLength > 0 else {
            throw NaturalConvectionCorrelationError
                .nonPositiveCharacteristicLength
        }
    }
}
