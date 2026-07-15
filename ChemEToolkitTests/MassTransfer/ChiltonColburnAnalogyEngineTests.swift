import Testing
@testable import ChemEToolkit

@Suite("Chilton–Colburn Analogy Engine")
struct ChiltonColburnAnalogyEngineTests {
    private let engine =
        ChiltonColburnAnalogyEngine()

    @Test(
        "Calculates j-factor, coefficient and Sherwood number"
    )
    func calculatesAnalogy() throws {
        let result = try engine.calculate(
            .init(
                fanningFrictionFactor:
                    0.005,
                reynoldsNumber: 100_000,
                schmidtNumber: 1,
                averageVelocity: 2
            )
        )

        #expect(
            result.massTransferJFactor
            == 0.0025
        )
        #expect(
            result
                .massTransferStantonNumber
            == 0.0025
        )
        #expect(
            result.massTransferCoefficient
            == 0.005
        )
        #expect(
            result.sherwoodNumber
            == 250
        )
    }

    @Test(
        "Preserves the Sc equals one identity"
    )
    func schmidtUnity() throws {
        let result = try engine.calculate(
            .init(
                fanningFrictionFactor:
                    0.01,
                reynoldsNumber: 10_000,
                schmidtNumber: 1,
                averageVelocity: 1
            )
        )

        #expect(
            result.massTransferJFactor
            == result
                .massTransferStantonNumber
        )
    }

    @Test(
        "Rejects invalid flow and transport ranges"
    )
    func validation() {
        #expect(
            throws:
                ChiltonColburnAnalogyError
                    .reynoldsOutOfRange
        ) {
            try engine.calculate(
                .init(
                    fanningFrictionFactor:
                        0.005,
                    reynoldsNumber: 9_999,
                    schmidtNumber: 1,
                    averageVelocity: 1
                )
            )
        }

        #expect(
            throws:
                ChiltonColburnAnalogyError
                    .schmidtOutOfRange
        ) {
            try engine.calculate(
                .init(
                    fanningFrictionFactor:
                        0.005,
                    reynoldsNumber:
                        10_000,
                    schmidtNumber: 0.5,
                    averageVelocity: 1
                )
            )
        }

        #expect(
            throws:
                ChiltonColburnAnalogyError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    fanningFrictionFactor:
                        .nan,
                    reynoldsNumber:
                        10_000,
                    schmidtNumber: 1,
                    averageVelocity: 1
                )
            )
        }
    }
}
