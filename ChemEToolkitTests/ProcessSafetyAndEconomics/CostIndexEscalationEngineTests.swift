import Testing
@testable import ChemEToolkit

@Suite("Cost Index Escalation Engine")
struct CostIndexEscalationEngineTests {
    private let engine =
        CostIndexEscalationEngine()

    @Test("Escalates a historical estimate")
    func escalation() throws {
        let result = try engine.calculate(
            .init(
                baseCost: 1_000_000,
                baseCostIndex: 600,
                targetCostIndex: 750,
                elapsedYears: 5
            )
        )

        #expect(
            abs(
                result.costIndexRatio
                - 1.25
            ) < 1e-12
        )

        #expect(
            result.escalatedCost
            == 1_250_000
        )

        #expect(
            result.absoluteCostChange
            == 250_000
        )

        #expect(
            abs(
                result.compoundAnnualEscalationRate
                - 0.045639552591273169
            ) < 1e-12
        )
    }

    @Test("Supports cost-index de-escalation")
    func deescalation() throws {
        let result = try engine.calculate(
            .init(
                baseCost: 1_000_000,
                baseCostIndex: 800,
                targetCostIndex: 600,
                elapsedYears: 4
            )
        )

        #expect(result.escalatedCost == 750_000)

        #expect(
            result.totalEscalationFraction
            == -0.25
        )
    }

    @Test("Rejects nonpositive elapsed years")
    func validation() {
        #expect(
            throws:
                CostIndexEscalationError
                    .nonPositiveElapsedYears
        ) {
            try engine.calculate(
                .init(
                    baseCost: 1_000_000,
                    baseCostIndex: 600,
                    targetCostIndex: 750,
                    elapsedYears: 0
                )
            )
        }
    }
}
