import Testing
@testable import ChemEToolkit

@Suite("CSTR PFR Sequence Engine")
struct CSTRPFRSequenceEngineTests {
    private let engine = CSTRPFRSequenceEngine()

    @Test("Calculates CSTR followed by PFR")
    func sequence() throws {
        let result = try engine.calculate(
            .init(
                inletConcentration: 10,
                volumetricFlowRate: 0.002,
                cstrVolume: 2,
                cstrRateConstant: 0.001,
                pfrVolume: 3,
                pfrRateConstant: 0.002
            )
        )

        #expect(abs(result.cstrOutletConcentration - 5) < 1e-12)
        #expect(abs(result.finalOutletConcentration - 0.24893534183931973) < 1e-12)
        #expect(abs(result.overallConversion - 0.975106465816068) < 1e-12)
        #expect(result.cstrSpaceTime == 1000)
        #expect(result.pfrSpaceTime == 1500)
    }

    @Test("Stage conversions close")
    func accounting() throws {
        let result = try engine.calculate(
            .init(
                inletConcentration: 10,
                volumetricFlowRate: 0.002,
                cstrVolume: 2,
                cstrRateConstant: 0.001,
                pfrVolume: 3,
                pfrRateConstant: 0.002
            )
        )

        #expect(abs(
            result.cstrStageConversion
            + result.pfrIncrementalConversionOnFeed
            - result.overallConversion
        ) < 1e-12)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: CSTRPFRSequenceError.nonPositiveVolumeOrRateConstant) {
            try engine.calculate(
                .init(
                    inletConcentration: 10,
                    volumetricFlowRate: 0.002,
                    cstrVolume: 0,
                    cstrRateConstant: 0.001,
                    pfrVolume: 3,
                    pfrRateConstant: 0.002
                )
            )
        }

        #expect(throws: CSTRPFRSequenceError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    inletConcentration: .nan,
                    volumetricFlowRate: 0.002,
                    cstrVolume: 2,
                    cstrRateConstant: 0.001,
                    pfrVolume: 3,
                    pfrRateConstant: 0.002
                )
            )
        }
    }
}
