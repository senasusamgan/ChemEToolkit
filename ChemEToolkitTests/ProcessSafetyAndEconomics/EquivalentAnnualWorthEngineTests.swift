import Testing
@testable import ChemEToolkit

@Suite("Equivalent Annual Worth Engine")
struct EquivalentAnnualWorthEngineTests {
    private let engine =
        EquivalentAnnualWorthEngine()

    @Test("Calculates annualized project worth")
    func annualWorth() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment:
                    10_000_000,
                annualNetCashFlow:
                    2_200_000,
                terminalValue:
                    1_000_000,
                projectLifeYears: 10,
                discountRateFraction: 0.1
            )
        )

        #expect(
            abs(
                result.capitalRecoveryFactor
                - 0.16274539488251152
            ) < 1e-12
        )

        #expect(
            abs(
                result.sinkingFundFactor
                - 0.062745394882511518
            ) < 1e-12
        )

        #expect(
            abs(
                result.annualizedInitialInvestment
                - 1627453.9488251153
            ) < 1e-8
        )

        #expect(
            abs(
                result.annualizedTerminalValue
                - 62745.394882511515
            ) < 1e-8
        )

        #expect(
            abs(
                result.equivalentAnnualWorth
                - 635291.44605739601
            ) < 1e-8
        )

        #expect(
            abs(
                result.presentWorth
                - 3903590.9219798381
            ) < 1e-8
        )
    }

    @Test("Zero discount uses uniform capital recovery")
    func zeroDiscount() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment: 100,
                annualNetCashFlow: 30,
                terminalValue: 20,
                projectLifeYears: 4,
                discountRateFraction: 0
            )
        )

        #expect(
            result.capitalRecoveryFactor
            == 0.25
        )

        #expect(
            result.sinkingFundFactor
            == 0.25
        )

        #expect(
            result.equivalentAnnualWorth
            == 10
        )
    }

    @Test("Rejects invalid project life")
    func validation() {
        #expect(
            throws:
                EquivalentAnnualWorthError
                    .invalidProjectLife
        ) {
            try engine.calculate(
                .init(
                    initialInvestment: 100,
                    annualNetCashFlow: 30,
                    terminalValue: 20,
                    projectLifeYears: 4.5,
                    discountRateFraction: 0.1
                )
            )
        }
    }
}
