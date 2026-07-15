import Foundation

struct ConvectiveMassTransferCorrelationsEngine:
    Sendable {

    func calculate(
        _ input:
            ConvectiveMassTransferCorrelationsInput
    ) throws
        -> ConvectiveMassTransferCorrelationsResult {

        let values = [
            input.reynoldsNumber,
            input.schmidtNumber,
            input.diffusivity,
            input.characteristicLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                ConvectiveMassTransferCorrelationsError
                    .nonFiniteInput
        }

        guard values.allSatisfy({ $0 > 0 }) else {
            throw
                ConvectiveMassTransferCorrelationsError
                    .nonPositiveProperty
        }

        guard
            (0.6...3000)
                .contains(input.schmidtNumber)
        else {
            throw
                ConvectiveMassTransferCorrelationsError
                    .schmidtOutOfRange
        }

        let sherwoodNumber: Double

        switch input.correlation {
        case .laminarFlatPlateAverage:
            guard input.reynoldsNumber <= 500_000 else {
                throw
                    ConvectiveMassTransferCorrelationsError
                        .reynoldsOutOfRange(
                            minimumExclusive: nil,
                            minimumInclusive: 0,
                            maximumInclusive:
                                500_000
                        )
            }

            sherwoodNumber =
                0.664
                * sqrt(input.reynoldsNumber)
                * pow(
                    input.schmidtNumber,
                    1 / 3
                )

        case .turbulentFlatPlateAverage:
            guard
                input.reynoldsNumber > 500_000,
                input.reynoldsNumber
                <= 10_000_000
            else {
                throw
                    ConvectiveMassTransferCorrelationsError
                        .reynoldsOutOfRange(
                            minimumExclusive:
                                500_000,
                            minimumInclusive: nil,
                            maximumInclusive:
                                10_000_000
                        )
            }

            sherwoodNumber =
                (
                    0.037
                    * pow(
                        input.reynoldsNumber,
                        0.8
                    )
                    - 871
                )
                * pow(
                    input.schmidtNumber,
                    1 / 3
                )
        }

        let coefficient =
            sherwoodNumber
            * input.diffusivity
            / input.characteristicLength

        guard
            sherwoodNumber.isFinite,
            coefficient.isFinite,
            sherwoodNumber > 0,
            coefficient > 0
        else {
            throw
                ConvectiveMassTransferCorrelationsError
                    .nonFiniteInput
        }

        return
            ConvectiveMassTransferCorrelationsResult(
                sherwoodNumber:
                    sherwoodNumber,
                massTransferCoefficient:
                    coefficient,
                correlationName:
                    input.correlation.fullName,
                validityDescription:
                    input.correlation
                        .validityDescription
            )
    }
}
