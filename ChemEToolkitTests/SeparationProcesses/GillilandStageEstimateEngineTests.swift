import Testing
@testable import ChemEToolkit

@Suite("Gilliland Stage Estimate Engine")
struct GillilandStageEstimateEngineTests {
    private let engine =
        GillilandStageEstimateEngine()

    @Test("Calculates theoretical stage estimate")
    func stageEstimate() throws {
        let result = try engine.calculate(
            .init(
                minimumTheoreticalStages: 6,
                minimumRefluxRatio: 1.2,
                operatingRefluxRatio: 1.8
            )
        )

        #expect(result.gillilandX > 0)
        #expect(result.gillilandX < 1)
        #expect(result.gillilandY >= 0)
        #expect(result.gillilandY < 1)

        #expect(
            result.estimatedTheoreticalStages
            >= 6
        )
    }

    @Test("Higher reflux reduces stage estimate")
    func refluxTrend() throws {
        let low = try engine.calculate(
            .init(
                minimumTheoreticalStages: 6,
                minimumRefluxRatio: 1.2,
                operatingRefluxRatio: 1.5
            )
        )

        let high = try engine.calculate(
            .init(
                minimumTheoreticalStages: 6,
                minimumRefluxRatio: 1.2,
                operatingRefluxRatio: 3
            )
        )

        #expect(
            high.estimatedTheoreticalStages
            < low.estimatedTheoreticalStages
        )
    }

    @Test("Rejects operating reflux at minimum")
    func validation() {
        #expect(
            throws:
                GillilandStageEstimateError
                    .operatingRefluxNotAboveMinimum
        ) {
            try engine.calculate(
                .init(
                    minimumTheoreticalStages: 6,
                    minimumRefluxRatio: 1.2,
                    operatingRefluxRatio: 1.2
                )
            )
        }
    }
}
