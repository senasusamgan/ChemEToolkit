import Foundation
struct ConversionFromRTDEngine: Sendable {
    func calculate(_ input: ConversionFromRTDInput) throws -> ConversionFromRTDResult {
        guard input.times.count == input.eValues.count else { throw ConversionFromRTDError.mismatchedArrays }
        guard input.times.count >= 2 else { throw ConversionFromRTDError.insufficientData }
        guard input.firstOrderRateConstant.isFinite, input.times.allSatisfy(\.isFinite), input.eValues.allSatisfy(\.isFinite) else { throw ConversionFromRTDError.nonFiniteInput }
        guard input.firstOrderRateConstant > 0 else { throw ConversionFromRTDError.nonPositiveRateConstant }
        guard zip(input.times, input.times.dropFirst()).allSatisfy({ $0 < $1 }) else { throw ConversionFromRTDError.nonIncreasingTime }
        guard input.eValues.allSatisfy({ $0 >= 0 }) else { throw ConversionFromRTDError.negativeEValue }

        func integrate(_ values: [Double]) -> Double {
            var total = 0.0
            for i in 0..<(input.times.count - 1) {
                total += 0.5 * (values[i] + values[i + 1]) * (input.times[i + 1] - input.times[i])
            }
            return total
        }

        let area = integrate(input.eValues)
        guard area > 0 else { throw ConversionFromRTDError.zeroRTDArea }
        let normalized = input.eValues.map { $0 / area }
        let survival = integrate(zip(input.times, normalized).map { t, e in
            exp(-input.firstOrderRateConstant * t) * e
        })
        let mean = integrate(zip(input.times, normalized).map(*))
        let conversion = 1 - survival
        let pfr = 1 - exp(-input.firstOrderRateConstant * mean)
        let cstr = input.firstOrderRateConstant * mean / (1 + input.firstOrderRateConstant * mean)

        guard [survival, mean, conversion, pfr, cstr].allSatisfy(\.isFinite) else {
            throw ConversionFromRTDError.numericalFailure
        }

        return .init(
            rawRTDArea: area,
            meanResidenceTime: mean,
            outletUnreactedFraction: survival,
            conversionFraction: conversion,
            idealPFRConversion: pfr,
            idealCSTRConversion: cstr,
            modelName: "Segregation-model first-order conversion from a discrete RTD",
            limitationDescription: "Uses trapezoidal integration of X = 1 − ∫exp(−kt)E(t)dt."
        )
    }
}
