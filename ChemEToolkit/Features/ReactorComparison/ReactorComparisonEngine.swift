import Foundation

struct ReactorComparisonEngine {
    func compare(
        input: ReactorComparisonInput
    ) throws -> ReactorComparisonResult {
        let rateConstant = try requiredPositiveValue(
            input.rateConstant,
            fieldName: "Rate Constant"
        )

        let conversion = try requiredConversion(
            input.conversion
        )

        let flowRate = try requiredPositiveValue(
            input.flowRate,
            fieldName: "Volumetric Flow Rate"
        )

        let pfrSpaceTime =
            -log(1 - conversion) /
            rateConstant

        let cstrSpaceTime =
            conversion /
            (
                rateConstant *
                (1 - conversion)
            )

        let pfrVolume =
            flowRate * pfrSpaceTime

        let cstrVolume =
            flowRate * cstrSpaceTime

        guard pfrVolume > 0 else {
            throw CalculationError.calculationFailed(
                reason:
                    "The calculated PFR volume must be greater than zero."
            )
        }

        let volumeDifference =
            cstrVolume - pfrVolume

        let volumeRatio =
            cstrVolume / pfrVolume

        return ReactorComparisonResult(
            conversion: conversion,
            pfrSpaceTime:
                try InputValidator.validateResult(
                    pfrSpaceTime
                ),
            cstrSpaceTime:
                try InputValidator.validateResult(
                    cstrSpaceTime
                ),
            pfrVolume:
                try InputValidator.validateResult(
                    pfrVolume
                ),
            cstrVolume:
                try InputValidator.validateResult(
                    cstrVolume
                ),
            volumeDifference:
                try InputValidator.validateResult(
                    volumeDifference
                ),
            volumeRatio:
                try InputValidator.validateResult(
                    volumeRatio
                )
        )
    }

    private func requiredPositiveValue(
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

    private func requiredConversion(
        _ value: Double?
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: "Conversion"
            )
        }

        guard value > 0, value < 1 else {
            throw CalculationError.calculationFailed(
                reason:
                    "Conversion must be greater than zero and less than one."
            )
        }

        return value
    }
}
