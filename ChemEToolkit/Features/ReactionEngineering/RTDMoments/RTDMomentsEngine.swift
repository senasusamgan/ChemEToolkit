struct RTDMomentsEngine: Sendable {
    func calculate(_ input: RTDMomentsInput) throws -> RTDMomentsResult {
        guard input.times.count == input.concentrations.count else { throw RTDMomentsError.mismatchedArrays }
        guard input.times.count >= 2 else { throw RTDMomentsError.insufficientData }
        guard input.times.allSatisfy(\.isFinite), input.concentrations.allSatisfy(\.isFinite) else { throw RTDMomentsError.nonFiniteInput }
        guard zip(input.times, input.times.dropFirst()).allSatisfy({ $0 < $1 }) else { throw RTDMomentsError.nonIncreasingTime }
        guard input.concentrations.allSatisfy({ $0 >= 0 }) else { throw RTDMomentsError.negativeConcentration }

        func integrate(_ values: [Double]) -> Double {
            var total = 0.0
            for i in 0..<(input.times.count - 1) {
                total += 0.5 * (values[i] + values[i + 1]) * (input.times[i + 1] - input.times[i])
            }
            return total
        }

        let area = integrate(input.concentrations)
        guard area > 0 else { throw RTDMomentsError.zeroTracerArea }
        let mean = integrate(zip(input.times, input.concentrations).map(*)) / area
        let variance = integrate(zip(input.times, input.concentrations).map { t, c in
            let d = t - mean
            return d * d * c
        }) / area
        let sd = variance.squareRoot()
        let cv = mean > 0 ? sd / mean : 0
        let dimVar = mean > 0 ? variance / (mean * mean) : 0
        let tanks = dimVar > 0 ? 1 / dimVar : .infinity

        guard [area, mean, variance, sd, cv, dimVar].allSatisfy(\.isFinite) else {
            throw RTDMomentsError.numericalFailure
        }

        return .init(
            tracerArea: area,
            meanResidenceTime: mean,
            variance: variance,
            standardDeviation: sd,
            coefficientOfVariation: cv,
            dimensionlessVariance: dimVar,
            equivalentTanksInSeries: tanks,
            modelName: "Pulse-tracer RTD moments using trapezoidal integration",
            limitationDescription: "Accuracy depends on sampling resolution and complete capture of the tracer tail."
        )
    }
}
