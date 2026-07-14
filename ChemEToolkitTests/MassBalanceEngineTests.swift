import Testing
@testable import ChemEToolkit

@Suite("Mass Balance Engine")
struct MassBalanceEngineTests {
    private let engine = MassBalanceEngine()
    private let tolerance = 0.00000001

    @Test("Calculates outlet flow")
    func calculatesOutletFlow() throws {
        let input = MassBalanceInput(
            flow1: 100,
            flow2: 50,
            composition1: nil,
            composition2: nil,
            outletComposition: nil
        )

        let result = try engine.solve(
            unknownVariable: .outletFlow,
            input: input
        )

        #expect(result.items.count == 1)
        #expect(result.items[0].variable == .outletFlow)
        #expect(
            abs(result.items[0].value - 150) <
            tolerance
        )
    }

    @Test("Calculates outlet composition")
    func calculatesOutletComposition() throws {
        let input = MassBalanceInput(
            flow1: 100,
            flow2: 50,
            composition1: 0.2,
            composition2: 0.8,
            outletComposition: nil
        )

        let result = try engine.solve(
            unknownVariable: .outletComposition,
            input: input
        )

        #expect(result.items.count == 2)

        #expect(
            abs(result.items[0].value - 150) <
            tolerance
        )

        #expect(
            result.items[1].variable ==
            .outletComposition
        )

        #expect(
            abs(result.items[1].value - 0.4) <
            tolerance
        )
    }

    @Test("Calculates inlet flow one")
    func calculatesInletFlowOne() throws {
        let input = MassBalanceInput(
            flow1: nil,
            flow2: 100,
            composition1: 0.2,
            composition2: 0.8,
            outletComposition: 0.5
        )

        let result = try engine.solve(
            unknownVariable: .inletFlow1,
            input: input
        )

        #expect(
            abs(result.items[0].value - 100) <
            tolerance
        )

        #expect(
            abs(result.items[1].value - 200) <
            tolerance
        )
    }

    @Test("Calculates inlet flow two")
    func calculatesInletFlowTwo() throws {
        let input = MassBalanceInput(
            flow1: 100,
            flow2: nil,
            composition1: 0.2,
            composition2: 0.8,
            outletComposition: 0.5
        )

        let result = try engine.solve(
            unknownVariable: .inletFlow2,
            input: input
        )

        #expect(
            abs(result.items[0].value - 100) <
            tolerance
        )

        #expect(
            abs(result.items[1].value - 200) <
            tolerance
        )
    }

    @Test("Rejects zero total outlet flow")
    func rejectsZeroTotalOutletFlow() {
        let input = MassBalanceInput(
            flow1: 0,
            flow2: 0,
            composition1: 0.2,
            composition2: 0.8,
            outletComposition: nil
        )

        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "The total outlet flow must be greater than zero."
            )
        ) {
            try engine.solve(
                unknownVariable: .outletComposition,
                input: input
            )
        }
    }

    @Test("Rejects non-unique inlet flow")
    func rejectsNonUniqueInletFlow() {
        let input = MassBalanceInput(
            flow1: nil,
            flow2: 100,
            composition1: 0.5,
            composition2: 0.8,
            outletComposition: 0.5
        )

        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "F₁ cannot be uniquely calculated with these composition values."
            )
        ) {
            try engine.solve(
                unknownVariable: .inletFlow1,
                input: input
            )
        }
    }

    @Test("Rejects physically impossible balance")
    func rejectsImpossibleBalance() {
        let input = MassBalanceInput(
            flow1: nil,
            flow2: 100,
            composition1: 0.2,
            composition2: 0.8,
            outletComposition: 0.9
        )

        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "These values produce a negative flow rate. Check whether the outlet composition lies between the two inlet compositions."
            )
        ) {
            try engine.solve(
                unknownVariable: .inletFlow1,
                input: input
            )
        }
    }
}
