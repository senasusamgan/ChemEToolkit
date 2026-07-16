import Foundation

struct TransferFunctionBuilderEngine:
    Sendable {

    private let tolerance = 1e-12

    func calculate(
        _ input: TransferFunctionBuilderInput
    ) throws -> TransferFunctionBuilderResult {

        let values = [
            input.numeratorLinearCoefficient,
            input.numeratorConstant,
            input.denominatorQuadraticCoefficient,
            input.denominatorLinearCoefficient,
            input.denominatorConstant,
            input.angularFrequency
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TransferFunctionBuilderError.nonFiniteInput
        }

        guard
            abs(input.denominatorQuadraticCoefficient) > tolerance
            || abs(input.denominatorLinearCoefficient) > tolerance
            || abs(input.denominatorConstant) > tolerance
        else {
            throw TransferFunctionBuilderError.zeroDenominatorPolynomial
        }

        guard input.angularFrequency >= 0 else {
            throw TransferFunctionBuilderError.negativeAngularFrequency
        }

        let numeratorOrder =
            abs(input.numeratorLinearCoefficient) > tolerance ? 1 : 0

        let denominatorOrder: Int
        if abs(input.denominatorQuadraticCoefficient) > tolerance {
            denominatorOrder = 2
        } else if abs(input.denominatorLinearCoefficient) > tolerance {
            denominatorOrder = 1
        } else {
            denominatorOrder = 0
        }

        let properness: String
        if numeratorOrder < denominatorOrder {
            properness = "Strictly proper"
        } else if numeratorOrder == denominatorOrder {
            properness = "Proper"
        } else {
            properness = "Improper"
        }

        let omega = input.angularFrequency

        let numeratorReal = input.numeratorConstant
        let numeratorImaginary =
            input.numeratorLinearCoefficient * omega

        let denominatorReal =
            input.denominatorConstant
            - input.denominatorQuadraticCoefficient
            * omega * omega

        let denominatorImaginary =
            input.denominatorLinearCoefficient * omega

        let denominatorMagnitudeSquared =
            denominatorReal * denominatorReal
            + denominatorImaginary * denominatorImaginary

        guard denominatorMagnitudeSquared > tolerance else {
            throw TransferFunctionBuilderError.frequencyDenominatorZero
        }

        let realPart =
            (
                numeratorReal * denominatorReal
                + numeratorImaginary * denominatorImaginary
            )
            / denominatorMagnitudeSquared

        let imaginaryPart =
            (
                numeratorImaginary * denominatorReal
                - numeratorReal * denominatorImaginary
            )
            / denominatorMagnitudeSquared

        let magnitude =
            (realPart * realPart + imaginaryPart * imaginaryPart).squareRoot()

        let phase =
            atan2(imaginaryPart, realPart)
            * 180 / Double.pi

        let dcGain =
            abs(input.denominatorConstant) > tolerance
            ? input.numeratorConstant / input.denominatorConstant
            : nil

        let stability: String

        if denominatorOrder == 2 {
            let normalizedA1 =
                input.denominatorLinearCoefficient
                / input.denominatorQuadraticCoefficient
            let normalizedA0 =
                input.denominatorConstant
                / input.denominatorQuadraticCoefficient

            stability =
                normalizedA1 > 0 && normalizedA0 > 0
                ? "Stable second-order denominator"
                : "Unstable or marginal second-order denominator"
        } else if denominatorOrder == 1 {
            let pole =
                -input.denominatorConstant
                / input.denominatorLinearCoefficient
            stability =
                pole < 0
                ? "Stable first-order denominator"
                : (pole == 0 ? "Marginal first-order denominator" : "Unstable first-order denominator")
        } else {
            stability = "Static gain: no dynamic poles"
        }

        let expression =
            "(\(input.numeratorLinearCoefficient)s + \(input.numeratorConstant)) / "
            + "(\(input.denominatorQuadraticCoefficient)s² + "
            + "\(input.denominatorLinearCoefficient)s + \(input.denominatorConstant))"

        guard
            realPart.isFinite,
            imaginaryPart.isFinite,
            magnitude.isFinite,
            phase.isFinite
        else {
            throw TransferFunctionBuilderError.numericalFailure
        }

        return .init(
            transferFunctionExpression: expression,
            numeratorOrder: numeratorOrder,
            denominatorOrder: denominatorOrder,
            propernessDescription: properness,
            realPart: realPart,
            imaginaryPart: imaginaryPart,
            magnitude: magnitude,
            phaseDegrees: phase,
            dcGain: dcGain,
            stabilityDescription: stability,
            modelName: "Polynomial transfer function up to first-order numerator and second-order denominator",
            limitationDescription: "Builds and evaluates one low-order SISO transfer function at s=jω. It does not factor arbitrary high-order polynomials or simplify pole-zero cancellations."
        )
    }
}
