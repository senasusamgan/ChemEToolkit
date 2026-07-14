import Foundation

struct MassBalanceEngine {
    private let tolerance = 1.0e-12

    func solve(
        unknownVariable: MassBalanceUnknown,
        input: MassBalanceInput
    ) throws -> MassBalanceSolution {
        switch unknownVariable {
        case .outletFlow:
            return try solveOutletFlow(
                input: input
            )

        case .outletComposition:
            return try solveOutletComposition(
                input: input
            )

        case .inletFlow1:
            return try solveInletFlow1(
                input: input
            )

        case .inletFlow2:
            return try solveInletFlow2(
                input: input
            )
        }
    }

    private func solveOutletFlow(
        input: MassBalanceInput
    ) throws -> MassBalanceSolution {
        let flow1 = try requiredFlow(
            input.flow1,
            fieldName: "Inlet Flow 1"
        )

        let flow2 = try requiredFlow(
            input.flow2,
            fieldName: "Inlet Flow 2"
        )

        let outletFlow = try InputValidator.validateResult(
            flow1 + flow2
        )

        return MassBalanceSolution(
            unknownVariable: .outletFlow,
            items: [
                MassBalanceResultItem(
                    variable: .outletFlow,
                    value: outletFlow
                )
            ]
        )
    }

    private func solveOutletComposition(
        input: MassBalanceInput
    ) throws -> MassBalanceSolution {
        let flow1 = try requiredFlow(
            input.flow1,
            fieldName: "Inlet Flow 1"
        )

        let flow2 = try requiredFlow(
            input.flow2,
            fieldName: "Inlet Flow 2"
        )

        let composition1 = try requiredComposition(
            input.composition1,
            fieldName: "Inlet Composition 1"
        )

        let composition2 = try requiredComposition(
            input.composition2,
            fieldName: "Inlet Composition 2"
        )

        let outletFlow = flow1 + flow2

        guard outletFlow > 0 else {
            throw CalculationError.calculationFailed(
                reason: "The total outlet flow must be greater than zero."
            )
        }

        let outletComposition =
            (
                flow1 * composition1 +
                flow2 * composition2
            ) / outletFlow

        let validatedOutletFlow =
            try InputValidator.validateResult(
                outletFlow
            )

        let validatedComposition =
            try InputValidator.validateResult(
                outletComposition
            )

        return MassBalanceSolution(
            unknownVariable: .outletComposition,
            items: [
                MassBalanceResultItem(
                    variable: .outletFlow,
                    value: validatedOutletFlow
                ),
                MassBalanceResultItem(
                    variable: .outletComposition,
                    value: validatedComposition
                )
            ]
        )
    }

    private func solveInletFlow1(
        input: MassBalanceInput
    ) throws -> MassBalanceSolution {
        let flow2 = try requiredFlow(
            input.flow2,
            fieldName: "Inlet Flow 2"
        )

        let composition1 = try requiredComposition(
            input.composition1,
            fieldName: "Inlet Composition 1"
        )

        let composition2 = try requiredComposition(
            input.composition2,
            fieldName: "Inlet Composition 2"
        )

        let outletComposition = try requiredComposition(
            input.outletComposition,
            fieldName: "Outlet Composition"
        )

        let denominator =
            outletComposition - composition1

        guard abs(denominator) > tolerance else {
            throw CalculationError.calculationFailed(
                reason:
                    "F₁ cannot be uniquely calculated with these composition values."
            )
        }

        let calculatedFlow1 =
            flow2 *
            (composition2 - outletComposition) /
            denominator

        guard calculatedFlow1 >= -tolerance else {
            throw impossibleBalanceError
        }

        let flow1 = max(0, calculatedFlow1)
        let outletFlow = flow1 + flow2

        return MassBalanceSolution(
            unknownVariable: .inletFlow1,
            items: [
                MassBalanceResultItem(
                    variable: .inletFlow1,
                    value: try InputValidator.validateResult(
                        flow1
                    )
                ),
                MassBalanceResultItem(
                    variable: .outletFlow,
                    value: try InputValidator.validateResult(
                        outletFlow
                    )
                )
            ]
        )
    }

    private func solveInletFlow2(
        input: MassBalanceInput
    ) throws -> MassBalanceSolution {
        let flow1 = try requiredFlow(
            input.flow1,
            fieldName: "Inlet Flow 1"
        )

        let composition1 = try requiredComposition(
            input.composition1,
            fieldName: "Inlet Composition 1"
        )

        let composition2 = try requiredComposition(
            input.composition2,
            fieldName: "Inlet Composition 2"
        )

        let outletComposition = try requiredComposition(
            input.outletComposition,
            fieldName: "Outlet Composition"
        )

        let denominator =
            outletComposition - composition2

        guard abs(denominator) > tolerance else {
            throw CalculationError.calculationFailed(
                reason:
                    "F₂ cannot be uniquely calculated with these composition values."
            )
        }

        let calculatedFlow2 =
            flow1 *
            (composition1 - outletComposition) /
            denominator

        guard calculatedFlow2 >= -tolerance else {
            throw impossibleBalanceError
        }

        let flow2 = max(0, calculatedFlow2)
        let outletFlow = flow1 + flow2

        return MassBalanceSolution(
            unknownVariable: .inletFlow2,
            items: [
                MassBalanceResultItem(
                    variable: .inletFlow2,
                    value: try InputValidator.validateResult(
                        flow2
                    )
                ),
                MassBalanceResultItem(
                    variable: .outletFlow,
                    value: try InputValidator.validateResult(
                        outletFlow
                    )
                )
            ]
        )
    }

    private func requiredFlow(
        _ value: Double?,
        fieldName: String
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        return try InputValidator.requireNonNegative(
            value,
            fieldName: fieldName
        )
    }

    private func requiredComposition(
        _ value: Double?,
        fieldName: String
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        return try InputValidator.requireFraction(
            value,
            fieldName: fieldName
        )
    }

    private var impossibleBalanceError: CalculationError {
        CalculationError.calculationFailed(
            reason:
                "These values produce a negative flow rate. Check whether the outlet composition lies between the two inlet compositions."
        )
    }
}
