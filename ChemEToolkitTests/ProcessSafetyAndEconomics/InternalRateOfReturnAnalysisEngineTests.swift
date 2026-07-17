import Testing
@testable import ChemEToolkit

@Suite("Internal Rate of Return Analysis Engine")
struct InternalRateOfReturnAnalysisEngineTests {
    private let engine =
        InternalRateOfReturnAnalysisEngine()

    @Test("Solves uniform-cash-flow IRR")
    func solvesIRR() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment:
                    10_000_000,
                annualNetCashFlow:
                    2_200_000,
                terminalValue:
                    1_000_000,
                projectLifeYears: 10,
                minimumSearchRate: -0.9,
                maximumSearchRate: 1
            )
        )

        #expect(
            abs(
                result.internalRateOfReturn
                - 0.18213719136167017
            ) < 1e-9
        )

        #expect(
            abs(
                result.netPresentValueAtIRR
            ) < 1e-6
        )

        #expect(result.iterationCount > 0)
    }

    @Test("Finds zero IRR for exact undiscounted recovery")
    func zeroIRR() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment: 100,
                annualNetCashFlow: 25,
                terminalValue: 0,
                projectLifeYears: 4,
                minimumSearchRate: -0.5,
                maximumSearchRate: 0.5
            )
        )

        #expect(
            abs(
                result.internalRateOfReturn
            ) < 1e-9
        )
    }

    @Test("Rejects search range without root")
    func validation() {
        #expect(
            throws:
                InternalRateOfReturnAnalysisError
                    .rootNotBracketed
        ) {
            try engine.calculate(
                .init(
                    initialInvestment: 100,
                    annualNetCashFlow: 1,
                    terminalValue: 0,
                    projectLifeYears: 2,
                    minimumSearchRate: 0,
                    maximumSearchRate: 1
                )
            )
        }
    }
}
