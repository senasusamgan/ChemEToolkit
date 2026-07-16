struct CubicRouthHurwitzStabilityEngine: Sendable {
    private let zeroTolerance = 1e-12

    func calculate(_ input: CubicRouthHurwitzStabilityInput) throws -> CubicRouthHurwitzStabilityResult {
        let values = [input.quadraticCoefficient, input.linearCoefficient, input.constantCoefficient]
        guard values.allSatisfy(\.isFinite) else { throw CubicRouthHurwitzStabilityError.nonFiniteInput }
        guard abs(input.quadraticCoefficient) > zeroTolerance else { throw CubicRouthHurwitzStabilityError.zeroQuadraticCoefficient }

        let firstOne = 1.0
        let firstTwo = input.quadraticCoefficient
        let numerator = input.quadraticCoefficient * input.linearCoefficient - input.constantCoefficient
        let firstThree = numerator / input.quadraticCoefficient
        let firstFour = input.constantCoefficient
        let firstColumn = [firstOne, firstTwo, firstThree, firstFour]

        guard firstColumn.allSatisfy(\.isFinite) else { throw CubicRouthHurwitzStabilityError.numericalFailure }
        guard firstColumn.allSatisfy({ abs($0) > zeroTolerance }) else { throw CubicRouthHurwitzStabilityError.singularRouthCase }

        var signChanges = 0
        for index in 1..<firstColumn.count {
            if firstColumn[index - 1] * firstColumn[index] < 0 { signChanges += 1 }
        }

        let stable = signChanges == 0 && firstColumn.allSatisfy({ $0 > 0 })
        let classification = stable
            ? "Asymptotically stable: all cubic Routh first-column terms are positive."
            : "Unstable: the first column contains \(signChanges) sign change(s), indicating the same number of right-half-plane roots."

        return .init(
            firstColumnOne: firstOne,
            firstColumnTwo: firstTwo,
            firstColumnThree: firstThree,
            firstColumnFour: firstFour,
            signChangeCount: signChanges,
            isAsymptoticallyStable: stable,
            stabilityMargin: numerator,
            classificationDescription: classification,
            modelName: "Routh–Hurwitz stability test for s³ + a₂s² + a₁s + a₀ = 0",
            limitationDescription: "Handles a monic cubic with no zero first-column elements. Marginal cases, rows of zeros and epsilon substitutions require a special-case procedure."
        )
    }
}
