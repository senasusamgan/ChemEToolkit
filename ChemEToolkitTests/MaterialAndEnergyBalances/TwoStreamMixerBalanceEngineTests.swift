import Testing
@testable import ChemEToolkit

@Suite("Two-Stream Mixer Balance Engine")
struct TwoStreamMixerBalanceEngineTests {
    private let engine =
        TwoStreamMixerBalanceEngine()

    @Test("Mixes two streams")
    func mixing() throws {
        let result = try engine.calculate(
            .init(
                stream1MassFlow: 100,
                stream1ComponentMassFraction: 0.2,
                stream2MassFlow: 50,
                stream2ComponentMassFraction: 0.8
            )
        )

        #expect(result.outletMassFlow == 150)
        #expect(result.stream1ComponentFlow == 20)
        #expect(result.stream2ComponentFlow == 40)
        #expect(result.outletComponentFlow == 60)

        #expect(
            abs(
                result.outletComponentMassFraction
                - 0.4
            ) < 1e-12
        )
    }

    @Test("Zero-flow stream does not affect mixture")
    func zeroStream() throws {
        let result = try engine.calculate(
            .init(
                stream1MassFlow: 100,
                stream1ComponentMassFraction: 0.3,
                stream2MassFlow: 0,
                stream2ComponentMassFraction: 0.9
            )
        )

        #expect(
            abs(
                result.outletComponentMassFraction
                - 0.3
            ) < 1e-12
        )
    }

    @Test("Rejects zero total outlet flow")
    func validation() {
        #expect(
            throws:
                TwoStreamMixerBalanceError
                    .zeroOutletFlow
        ) {
            try engine.calculate(
                .init(
                    stream1MassFlow: 0,
                    stream1ComponentMassFraction: 0.2,
                    stream2MassFlow: 0,
                    stream2ComponentMassFraction: 0.8
                )
            )
        }
    }
}
