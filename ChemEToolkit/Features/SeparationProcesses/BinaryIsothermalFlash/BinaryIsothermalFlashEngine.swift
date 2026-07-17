struct BinaryIsothermalFlashEngine:
    Sendable {

    func calculate(
        _ input:
            BinaryIsothermalFlashInput
    ) throws
        -> BinaryIsothermalFlashResult {

        let values = [
            input.feedMolarFlow,
            input.feedMoleFraction1,
            input.equilibriumRatio1,
            input.equilibriumRatio2
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinaryIsothermalFlashError
                .nonFiniteInput
        }

        guard input.feedMolarFlow > 0 else {
            throw BinaryIsothermalFlashError
                .nonPositiveFeedFlow
        }

        guard
            input.feedMoleFraction1 >= 0,
            input.feedMoleFraction1 <= 1
        else {
            throw BinaryIsothermalFlashError
                .fractionOutsideRange
        }

        guard
            input.equilibriumRatio1 > 0,
            input.equilibriumRatio2 > 0
        else {
            throw BinaryIsothermalFlashError
                .nonPositiveEquilibriumRatio
        }

        let z1 =
            input.feedMoleFraction1

        let z2 =
            1 - z1

        func rachfordRice(
            _ beta: Double
        ) -> Double {
            z1
                * (
                    input.equilibriumRatio1 - 1
                )
                / (
                    1
                    + beta
                        * (
                            input.equilibriumRatio1 - 1
                        )
                )
            + z2
                * (
                    input.equilibriumRatio2 - 1
                )
                / (
                    1
                    + beta
                        * (
                            input.equilibriumRatio2 - 1
                        )
                )
        }

        let f0 =
            rachfordRice(0)

        let f1 =
            rachfordRice(1)

        let beta: Double
        let phase: String

        if f0 <= 0 {
            beta = 0
            phase = "Single liquid phase"
        } else if f1 >= 0 {
            beta = 1
            phase = "Single vapor phase"
        } else {
            var low = 0.0
            var high = 1.0

            for _ in 0..<120 {
                let middle =
                    0.5 * (low + high)

                if rachfordRice(middle) > 0 {
                    low = middle
                } else {
                    high = middle
                }
            }

            beta =
                0.5 * (low + high)

            phase = "Two-phase flash"
        }

        let liquidDenominator1 =
            1
            + beta
                * (
                    input.equilibriumRatio1 - 1
                )

        let liquidDenominator2 =
            1
            + beta
                * (
                    input.equilibriumRatio2 - 1
                )

        let rawX1 =
            z1 / liquidDenominator1

        let rawX2 =
            z2 / liquidDenominator2

        let rawY1 =
            input.equilibriumRatio1
            * rawX1

        let rawY2 =
            input.equilibriumRatio2
            * rawX2

        let xSum =
            rawX1 + rawX2

        let ySum =
            rawY1 + rawY2

        let x1 =
            rawX1 / xSum

        let x2 =
            rawX2 / xSum

        let y1 =
            rawY1 / ySum

        let y2 =
            rawY2 / ySum

        let vaporFlow =
            input.feedMolarFlow
            * beta

        let liquidFlow =
            input.feedMolarFlow
            - vaporFlow

        let outputs = [
            beta,
            vaporFlow,
            liquidFlow,
            x1,
            x2,
            y1,
            y2
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            beta >= 0,
            beta <= 1,
            x1 >= 0,
            x1 <= 1,
            y1 >= 0,
            y1 <= 1
        else {
            throw BinaryIsothermalFlashError
                .numericalFailure
        }

        return .init(
            vaporFraction:
                beta,
            liquidFraction:
                1 - beta,
            vaporMolarFlow:
                vaporFlow,
            liquidMolarFlow:
                liquidFlow,
            liquidMoleFraction1:
                x1,
            liquidMoleFraction2:
                x2,
            vaporMoleFraction1:
                y1,
            vaporMoleFraction2:
                y2,
            phaseDescription:
                phase,
            modelName:
                "Binary Rachford–Rice isothermal flash",
            limitationDescription:
                "Uses constant equilibrium ratios Kᵢ at the selected flash temperature and pressure."
        )
    }
}
