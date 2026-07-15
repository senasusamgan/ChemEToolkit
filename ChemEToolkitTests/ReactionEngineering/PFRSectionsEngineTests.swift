import Foundation
import Testing
@testable import ChemEToolkit

@Suite("PFR Sections Engine")
struct PFRSectionsEngineTests {
    private let engine = PFRSectionsEngine()

    @Test("Calculates three PFR sections")
    func sections() throws {
        let result = try engine.calculate(
            .init(
                inletConcentration: 10,
                volumetricFlowRate: 0.002,
                sectionOneVolume: 1,
                sectionOneRateConstant: 0.001,
                sectionTwoVolume: 1.5,
                sectionTwoRateConstant: 0.002,
                sectionThreeVolume: 2,
                sectionThreeRateConstant: 0.003
            )
        )

        #expect(abs(result.outletConcentrationSectionOne - 6.065306597126334) < 1e-12)
        #expect(abs(result.outletConcentrationSectionTwo - 1.353352832366127) < 1e-12)
        #expect(abs(result.outletConcentrationSectionThree - 0.06737946999085467) < 1e-12)
        #expect(abs(result.overallConversion - 0.9932620530009145) < 1e-12)
        #expect(result.totalReactorVolume == 4.5)
        #expect(result.totalSpaceTime == 2250)
    }

    @Test("Equal rates match one equivalent PFR")
    func equalRates() throws {
        let result = try engine.calculate(
            .init(
                inletConcentration: 10,
                volumetricFlowRate: 0.002,
                sectionOneVolume: 1,
                sectionOneRateConstant: 0.002,
                sectionTwoVolume: 1,
                sectionTwoRateConstant: 0.002,
                sectionThreeVolume: 1,
                sectionThreeRateConstant: 0.002
            )
        )

        #expect(abs(result.outletConcentrationSectionThree - 10 * exp(-3)) < 1e-12)
        #expect(result.residenceTimeWeightedRateConstant == 0.002)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: PFRSectionsError.nonPositiveSectionVolumeOrRateConstant) {
            try engine.calculate(
                .init(
                    inletConcentration: 10,
                    volumetricFlowRate: 0.002,
                    sectionOneVolume: 0,
                    sectionOneRateConstant: 0.001,
                    sectionTwoVolume: 1,
                    sectionTwoRateConstant: 0.002,
                    sectionThreeVolume: 1,
                    sectionThreeRateConstant: 0.003
                )
            )
        }

        #expect(throws: PFRSectionsError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    inletConcentration: .nan,
                    volumetricFlowRate: 0.002,
                    sectionOneVolume: 1,
                    sectionOneRateConstant: 0.001,
                    sectionTwoVolume: 1,
                    sectionTwoRateConstant: 0.002,
                    sectionThreeVolume: 1,
                    sectionThreeRateConstant: 0.003
                )
            )
        }
    }
}
