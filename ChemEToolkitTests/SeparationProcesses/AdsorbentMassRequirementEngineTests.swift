import Testing
@testable import ChemEToolkit

@Suite("Adsorbent Mass Requirement Engine")
struct AdsorbentMassRequirementEngineTests {
    private let engine =
        AdsorbentMassRequirementEngine()

    @Test("Calculates design adsorbent inventory")
    func massRequirement() throws {
        let result =
            try engine.calculate(
                .init(
                    soluteFeedRate: 2,
                    cycleTime: 8,
                    equilibriumCapacity: 0.20,
                    utilizationFraction: 0.70,
                    safetyFactor: 1.20
                )
            )

        #expect(
            abs(
                result.solutePerCycle
                - 16
            ) < 1e-12
        )

        #expect(
            result.designAdsorbentMass
            > result.theoreticalAdsorbentMass
        )
    }

    @Test("Higher utilization lowers mass requirement")
    func utilizationTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    soluteFeedRate: 2,
                    cycleTime: 8,
                    equilibriumCapacity: 0.20,
                    utilizationFraction: 0.50,
                    safetyFactor: 1
                )
            )

        let high =
            try engine.calculate(
                .init(
                    soluteFeedRate: 2,
                    cycleTime: 8,
                    equilibriumCapacity: 0.20,
                    utilizationFraction: 0.90,
                    safetyFactor: 1
                )
            )

        #expect(
            high.designAdsorbentMass
            < low.designAdsorbentMass
        )
    }

    @Test("Rejects utilization above one")
    func validation() {
        #expect(
            throws:
                AdsorbentMassRequirementError
                    .invalidUtilization
        ) {
            try engine.calculate(
                .init(
                    soluteFeedRate: 2,
                    cycleTime: 8,
                    equilibriumCapacity: 0.20,
                    utilizationFraction: 1.1,
                    safetyFactor: 1.2
                )
            )
        }
    }
}
