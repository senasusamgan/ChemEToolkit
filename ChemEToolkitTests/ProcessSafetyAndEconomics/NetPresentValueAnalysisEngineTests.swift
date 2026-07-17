import Testing
@testable import ChemEToolkit

@Suite("Net Present Value Analysis Engine")
struct NetPresentValueAnalysisEngineTests {
    private let engine =
        NetPresentValueAnalysisEngine()

    @Test("Calculates discounted project value")
    func discountedValue() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment:
                    10000000,
                annualNetCashFlow:
                    2000000,
                projectLifeYears: 10,
                discountRateFraction: 0.1,
                terminalValue:
                    1000000
            )
        )

        #expect(
            abs(
                result.presentValueOfAnnualCashFlows
                - 12289134.21140936
            ) < 1e-8
        )

        #expect(
            abs(
                result.presentValueOfTerminalValue
                - 385543.28942953143
            ) < 1e-8
        )

        #expect(
            abs(
                result.netPresentValue
                - 2674677.5008388907
            ) < 1e-8
        )

        #expect(
            abs(
                result.profitabilityIndex
                - 1.2674677500838891
            ) < 1e-12
        )

        #expect(result.netPresentValue > 0)
    }

    @Test("Zero discount rate reduces to undiscounted total")
    func zeroDiscountRate() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment: 100,
                annualNetCashFlow: 30,
                projectLifeYears: 4,
                discountRateFraction: 0,
                terminalValue: 10
            )
        )

        #expect(
            result.presentValueOfAnnualCashFlows
            == 120
        )

        #expect(
            result.presentValueOfTerminalValue
            == 10
        )

        #expect(result.netPresentValue == 30)
    }

    @Test("Rejects invalid project life")
    func validation() {
        #expect(
            throws:
                NetPresentValueAnalysisError
                    .invalidProjectLife
        ) {
            try engine.calculate(
                .init(
                    initialInvestment: 100,
                    annualNetCashFlow: 30,
                    projectLifeYears: 4.5,
                    discountRateFraction: 0.1,
                    terminalValue: 10
                )
            )
        }
    }
}
