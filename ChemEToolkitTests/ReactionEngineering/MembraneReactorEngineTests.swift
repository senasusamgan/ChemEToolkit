import Testing
@testable import ChemEToolkit

@Suite("Membrane Reactor Engine")
struct MembraneReactorEngineTests {
    private let engine =
        MembraneReactorEngine()

    @Test("Selective removal improves reversible conversion")
    func membraneEnhancement() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                inletConcentrationB: 0,
                forwardRateConstant: 1,
                reverseRateConstant: 0.5,
                membraneRemovalConstant: 1,
                spaceTime: 2
            )
        )

        #expect(
            abs(
                result.outletConcentrationA
                - 0.25135817374386321
            ) < 1e-7
        )
        #expect(
            abs(
                result.outletConcentrationB
                - 0.23304253485512785
            ) < 1e-7
        )
        #expect(
            abs(
                result.removedProductEquivalent
                - 0.51559929140096861
            ) < 1e-7
        )
        #expect(
            result.conversionOfA
            > result.conversionWithoutMembrane
        )
        #expect(
            abs(
                result.massBalanceClosure
                - 1
            ) < 1e-7
        )
    }

    @Test("Zero removal matches reference conversion")
    func zeroRemoval() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                inletConcentrationB: 0,
                forwardRateConstant: 1,
                reverseRateConstant: 0.5,
                membraneRemovalConstant: 0,
                spaceTime: 2
            )
        )

        #expect(
            abs(
                result.conversionOfA
                - result.conversionWithoutMembrane
            ) < 1e-10
        )
        #expect(
            abs(result.removedProductEquivalent)
            < 1e-12
        )
    }

    @Test("Rejects invalid membrane inputs")
    func validation() {
        #expect(
            throws:
                MembraneReactorError
                    .invalidRateConstant
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    inletConcentrationB: 0,
                    forwardRateConstant: 1,
                    reverseRateConstant: 0.5,
                    membraneRemovalConstant: -1,
                    spaceTime: 2
                )
            )
        }
    }
}
