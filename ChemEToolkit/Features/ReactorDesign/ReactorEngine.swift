import Foundation

struct ReactorEngine {
    func solve(
        reactorType: ReactorType,
        calculation: ReactorCalculation,
        input: ReactorInput
    ) throws -> ReactorSolution {
        guard ReactorCalculation
            .options(for: reactorType)
            .contains(calculation)
        else {
            throw CalculationError.calculationFailed(
                reason:
                    "\(calculation.title) is not supported for \(reactorType.title)."
            )
        }

        switch reactorType {
        case .batch:
            return try solveBatch(
                calculation: calculation,
                input: input
            )

        case .cstr:
            return try solveFlowReactor(
                reactorType: .cstr,
                calculation: calculation,
                input: input
            )

        case .pfr:
            return try solveFlowReactor(
                reactorType: .pfr,
                calculation: calculation,
                input: input
            )
        }
    }

    private func solveBatch(
        calculation: ReactorCalculation,
        input: ReactorInput
    ) throws -> ReactorSolution {
        switch calculation {
        case .conversion:
            let rateConstant = try requiredPositive(
                input.rateConstant,
                fieldName: "Rate Constant"
            )

            let time = try requiredNonNegative(
                input.time,
                fieldName: "Reaction Time"
            )

            let conversion =
                1 - exp(-rateConstant * time)

            return try makeSolution(
                reactorType: .batch,
                calculation: .conversion,
                values: [
                    (.conversion, conversion)
                ]
            )

        case .time:
            let rateConstant = try requiredPositive(
                input.rateConstant,
                fieldName: "Rate Constant"
            )

            let conversion = try requiredConversion(
                input.conversion
            )

            let time =
                -log(1 - conversion) /
                rateConstant

            return try makeSolution(
                reactorType: .batch,
                calculation: .time,
                values: [
                    (.time, time)
                ]
            )

        case .rateConstant:
            let conversion = try requiredConversion(
                input.conversion
            )

            let time = try requiredPositive(
                input.time,
                fieldName: "Reaction Time"
            )

            let rateConstant =
                -log(1 - conversion) /
                time

            return try makeSolution(
                reactorType: .batch,
                calculation: .rateConstant,
                values: [
                    (.rateConstant, rateConstant)
                ]
            )

        case .spaceTime, .volume:
            throw CalculationError.calculationFailed(
                reason:
                    "\(calculation.title) is not supported for a Batch Reactor."
            )
        }
    }

    private func solveFlowReactor(
        reactorType: ReactorType,
        calculation: ReactorCalculation,
        input: ReactorInput
    ) throws -> ReactorSolution {
        switch calculation {
        case .conversion:
            let rateConstant = try requiredPositive(
                input.rateConstant,
                fieldName: "Rate Constant"
            )

            let spaceTime = try requiredNonNegative(
                input.spaceTime,
                fieldName: "Space Time"
            )

            let conversion: Double

            switch reactorType {
            case .cstr:
                let rateTimeProduct =
                    rateConstant * spaceTime

                conversion =
                    rateTimeProduct /
                    (1 + rateTimeProduct)

            case .pfr:
                conversion =
                    1 - exp(
                        -rateConstant * spaceTime
                    )

            case .batch:
                throw CalculationError.calculationFailed(
                    reason: "Invalid flow reactor type."
                )
            }

            return try makeSolution(
                reactorType: reactorType,
                calculation: .conversion,
                values: [
                    (.conversion, conversion)
                ]
            )

        case .spaceTime:
            let rateConstant = try requiredPositive(
                input.rateConstant,
                fieldName: "Rate Constant"
            )

            let conversion = try requiredConversion(
                input.conversion
            )

            let spaceTime = calculateSpaceTime(
                reactorType: reactorType,
                rateConstant: rateConstant,
                conversion: conversion
            )

            return try makeSolution(
                reactorType: reactorType,
                calculation: .spaceTime,
                values: [
                    (.spaceTime, spaceTime)
                ]
            )

        case .volume:
            let rateConstant = try requiredPositive(
                input.rateConstant,
                fieldName: "Rate Constant"
            )

            let conversion = try requiredConversion(
                input.conversion
            )

            let flowRate = try requiredPositive(
                input.flowRate,
                fieldName: "Volumetric Flow Rate"
            )

            let spaceTime = calculateSpaceTime(
                reactorType: reactorType,
                rateConstant: rateConstant,
                conversion: conversion
            )

            let reactorVolume =
                flowRate * spaceTime

            return try makeSolution(
                reactorType: reactorType,
                calculation: .volume,
                values: [
                    (.spaceTime, spaceTime),
                    (.volume, reactorVolume)
                ]
            )

        case .time, .rateConstant:
            throw CalculationError.calculationFailed(
                reason:
                    "\(calculation.title) is not supported for \(reactorType.title)."
            )
        }
    }

    private func calculateSpaceTime(
        reactorType: ReactorType,
        rateConstant: Double,
        conversion: Double
    ) -> Double {
        switch reactorType {
        case .cstr:
            return conversion /
                (
                    rateConstant *
                    (1 - conversion)
                )

        case .pfr:
            return
                -log(1 - conversion) /
                rateConstant

        case .batch:
            return 0
        }
    }

    private func requiredPositive(
        _ value: Double?,
        fieldName: String
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        return try InputValidator.requirePositive(
            value,
            fieldName: fieldName
        )
    }

    private func requiredNonNegative(
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

    private func requiredConversion(
        _ value: Double?
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: "Conversion"
            )
        }

        guard value >= 0, value < 1 else {
            throw CalculationError.calculationFailed(
                reason:
                    "Conversion must be at least zero and less than one."
            )
        }

        return value
    }

    private func makeSolution(
        reactorType: ReactorType,
        calculation: ReactorCalculation,
        values: [
            (
                ReactorResultVariable,
                Double
            )
        ]
    ) throws -> ReactorSolution {
        let items = try values.map {
            variable,
            value in

            ReactorResultItem(
                variable: variable,
                value:
                    try InputValidator
                        .validateResult(value)
            )
        }

        return ReactorSolution(
            reactorType: reactorType,
            calculation: calculation,
            items: items
        )
    }
}
