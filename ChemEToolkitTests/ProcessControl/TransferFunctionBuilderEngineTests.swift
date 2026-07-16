import Testing
@testable import ChemEToolkit

@Suite("Transfer Function Builder Engine")
struct TransferFunctionBuilderEngineTests {
    private let engine = TransferFunctionBuilderEngine()

    @Test("Builds and evaluates a stable second-order transfer function")
    func secondOrder() throws {
        let result = try engine.calculate(
            .init(
                numeratorLinearCoefficient: 1,
                numeratorConstant: 2,
                denominatorQuadraticCoefficient: 1,
                denominatorLinearCoefficient: 3,
                denominatorConstant: 2,
                angularFrequency: 1
            )
        )

        #expect(result.numeratorOrder == 1)
        #expect(result.denominatorOrder == 2)
        #expect(result.propernessDescription == "Strictly proper")
        #expect(result.dcGain == 1)
        #expect(result.stabilityDescription == "Stable second-order denominator")
        #expect(abs(result.realPart - 0.5) < 1e-12)
        #expect(abs(result.imaginaryPart + 0.5) < 1e-12)
    }

    @Test("Handles first-order and static denominators")
    func lowerOrders() throws {
        let firstOrder = try engine.calculate(
            .init(
                numeratorLinearCoefficient: 0,
                numeratorConstant: 2,
                denominatorQuadraticCoefficient: 0,
                denominatorLinearCoefficient: 1,
                denominatorConstant: 2,
                angularFrequency: 0
            )
        )
        #expect(firstOrder.denominatorOrder == 1)
        #expect(firstOrder.stabilityDescription == "Stable first-order denominator")

        let staticGain = try engine.calculate(
            .init(
                numeratorLinearCoefficient: 0,
                numeratorConstant: 4,
                denominatorQuadraticCoefficient: 0,
                denominatorLinearCoefficient: 0,
                denominatorConstant: 2,
                angularFrequency: 5
            )
        )
        #expect(staticGain.magnitude == 2)
    }

    @Test("Rejects invalid denominator")
    func validation() {
        #expect(throws: TransferFunctionBuilderError.zeroDenominatorPolynomial) {
            try engine.calculate(
                .init(
                    numeratorLinearCoefficient: 1,
                    numeratorConstant: 2,
                    denominatorQuadraticCoefficient: 0,
                    denominatorLinearCoefficient: 0,
                    denominatorConstant: 0,
                    angularFrequency: 1
                )
            )
        }
    }
}
