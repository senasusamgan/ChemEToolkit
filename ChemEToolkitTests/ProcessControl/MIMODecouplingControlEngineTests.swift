import Testing
@testable import ChemEToolkit

@Suite("MIMO Decoupling Control Engine")
struct MIMODecouplingControlEngineTests {
    private let engine =
        MIMODecouplingControlEngine()

    @Test("Calculates RGA and inverse gain matrix")
    func decoupling() throws {
        let result = try engine.calculate(
            .init(
                gain11: 2,
                gain12: 0.5,
                gain21: 0.4,
                gain22: 1.5
            )
        )

        #expect(
            abs(
                result.determinant
                - 2.7999999999999998
            ) < 1e-12
        )

        #expect(
            abs(
                result.relativeGain11
                - 1.0714285714285714
            ) < 1e-12
        )

        #expect(
            abs(
                result.relativeGain12
                - -0.071428571428571438
            ) < 1e-12
        )

        #expect(
            abs(
                result.relativeGain11
                + result.relativeGain12
                - 1
            ) < 1e-12
        )

        #expect(
            result.pairingRecommendation
                .contains("y₁↔u₁")
        )
    }

    @Test("Crossed process recommends crossed pairing")
    func crossedPairing() throws {
        let result = try engine.calculate(
            .init(
                gain11: 0.2,
                gain12: 2,
                gain21: 1.5,
                gain22: 0.1
            )
        )

        #expect(
            result.pairingRecommendation
                .contains("y₁↔u₂")
        )
    }

    @Test("Rejects singular gain matrix")
    func validation() {
        #expect(
            throws:
                MIMODecouplingControlError
                    .singularGainMatrix
        ) {
            try engine.calculate(
                .init(
                    gain11: 1,
                    gain12: 2,
                    gain21: 2,
                    gain22: 4
                )
            )
        }
    }
}
