import Testing
@testable import ChemEToolkit

@Suite(
    "Convective Mass-Transfer Correlations Engine"
)
struct ConvectiveMassTransferCorrelationsEngineTests {
    private let engine =
        ConvectiveMassTransferCorrelationsEngine()

    @Test(
        "Calculates the average laminar flat-plate result"
    )
    func laminarFlatPlate() throws {
        let result = try engine.calculate(
            .init(
                correlation:
                    .laminarFlatPlateAverage,
                reynoldsNumber: 100_000,
                schmidtNumber: 1,
                diffusivity: 2e-5,
                characteristicLength: 1
            )
        )

        #expect(
            abs(
                result.sherwoodNumber
                - 209.9752366351804
            ) < 1e-10
        )

        #expect(
            abs(
                result.massTransferCoefficient
                - 0.0041995047327036085
            ) < 1e-14
        )
    }

    @Test(
        "Accepts the laminar transition boundary"
    )
    func laminarBoundary() throws {
        let result = try engine.calculate(
            .init(
                correlation:
                    .laminarFlatPlateAverage,
                reynoldsNumber: 500_000,
                schmidtNumber: 1,
                diffusivity: 1e-5,
                characteristicLength: 1
            )
        )

        #expect(result.sherwoodNumber > 0)
    }

    @Test(
        "Rejects invalid Reynolds, Schmidt and finite values"
    )
    func validation() {
        #expect(
            throws:
                ConvectiveMassTransferCorrelationsError
                    .reynoldsOutOfRange(
                        minimumExclusive:
                            500_000,
                        minimumInclusive: nil,
                        maximumInclusive:
                            10_000_000
                    )
        ) {
            try engine.calculate(
                .init(
                    correlation:
                        .turbulentFlatPlateAverage,
                    reynoldsNumber: 500_000,
                    schmidtNumber: 1,
                    diffusivity: 1e-5,
                    characteristicLength: 1
                )
            )
        }

        #expect(
            throws:
                ConvectiveMassTransferCorrelationsError
                    .schmidtOutOfRange
        ) {
            try engine.calculate(
                .init(
                    correlation:
                        .laminarFlatPlateAverage,
                    reynoldsNumber: 1,
                    schmidtNumber: 0.5,
                    diffusivity: 1,
                    characteristicLength: 1
                )
            )
        }

        #expect(
            throws:
                ConvectiveMassTransferCorrelationsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    correlation:
                        .laminarFlatPlateAverage,
                    reynoldsNumber: .nan,
                    schmidtNumber: 1,
                    diffusivity: 1,
                    characteristicLength: 1
                )
            )
        }
    }
}
