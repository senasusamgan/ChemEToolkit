import Foundation

struct ForcedConvectionCorrelationEngine {

    func calculate(
        input: ForcedConvectionCorrelationInput
    ) throws -> ForcedConvectionCorrelationResult {

        try validate(input)

        let nusseltNumber: Double
        let correlation: ForcedConvectionCorrelationUsed

        switch input.geometry {
        case .internalCircularTube:
            if input.reynoldsNumber < 2_300 {
                nusseltNumber = 3.66
                correlation = .siederTateLaminar
            } else if input.reynoldsNumber >= 10_000,
                      input.prandtlNumber >= 0.7,
                      input.prandtlNumber <= 160 {
                nusseltNumber =
                    0.023
                    * pow(input.reynoldsNumber, 0.8)
                    * pow(input.prandtlNumber, 0.4)
                correlation = .dittusBoelter
            } else {
                throw ForcedConvectionCorrelationError
                    .unsupportedRange
            }

        case .externalFlatPlate:
            if input.reynoldsNumber <= 500_000 {
                nusseltNumber =
                    0.664
                    * sqrt(input.reynoldsNumber)
                    * pow(input.prandtlNumber, 1.0 / 3.0)
                correlation = .flatPlateLaminar
            } else {
                nusseltNumber =
                    (
                        0.037
                        * pow(input.reynoldsNumber, 0.8)
                        - 871
                    )
                    * pow(input.prandtlNumber, 1.0 / 3.0)
                correlation = .flatPlateTurbulent
            }
        }

        let heatTransferCoefficient =
            nusseltNumber
            * input.fluidThermalConductivity
            / input.characteristicLength

        return ForcedConvectionCorrelationResult(
            nusseltNumber: nusseltNumber,
            heatTransferCoefficient:
                heatTransferCoefficient,
            correlationUsed: correlation
        )
    }

    private func validate(
        _ input: ForcedConvectionCorrelationInput
    ) throws {
        let values = [
            input.reynoldsNumber,
            input.prandtlNumber,
            input.fluidThermalConductivity,
            input.characteristicLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ForcedConvectionCorrelationError
                .nonFiniteInput
        }

        guard input.reynoldsNumber > 0 else {
            throw ForcedConvectionCorrelationError
                .nonPositiveReynoldsNumber
        }

        guard input.prandtlNumber > 0 else {
            throw ForcedConvectionCorrelationError
                .nonPositivePrandtlNumber
        }

        guard input.fluidThermalConductivity > 0 else {
            throw ForcedConvectionCorrelationError
                .nonPositiveThermalConductivity
        }

        guard input.characteristicLength > 0 else {
            throw ForcedConvectionCorrelationError
                .nonPositiveCharacteristicLength
        }
    }
}
