import Foundation

struct ChiltonColburnAnalogyEngine:
    Sendable {

    func calculate(
        _ input: ChiltonColburnAnalogyInput
    ) throws -> ChiltonColburnAnalogyResult {

        let values = [
            input.fanningFrictionFactor,
            input.reynoldsNumber,
            input.schmidtNumber,
            input.averageVelocity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ChiltonColburnAnalogyError
                .nonFiniteInput
        }

        guard values.allSatisfy({ $0 > 0 }) else {
            throw ChiltonColburnAnalogyError
                .nonPositiveProperty
        }

        guard input.reynoldsNumber >= 10_000 else {
            throw ChiltonColburnAnalogyError
                .reynoldsOutOfRange
        }

        guard
            (0.6...3000)
                .contains(input.schmidtNumber)
        else {
            throw ChiltonColburnAnalogyError
                .schmidtOutOfRange
        }

        let jFactor =
            input.fanningFrictionFactor
            / 2

        let stantonNumber =
            jFactor
            / pow(
                input.schmidtNumber,
                2 / 3
            )

        let coefficient =
            stantonNumber
            * input.averageVelocity

        let sherwoodNumber =
            jFactor
            * input.reynoldsNumber
            * pow(
                input.schmidtNumber,
                1 / 3
            )

        let results = [
            jFactor,
            stantonNumber,
            coefficient,
            sherwoodNumber
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 > 0 })
        else {
            throw ChiltonColburnAnalogyError
                .nonFiniteInput
        }

        return ChiltonColburnAnalogyResult(
            massTransferJFactor: jFactor,
            massTransferStantonNumber:
                stantonNumber,
            massTransferCoefficient:
                coefficient,
            sherwoodNumber:
                sherwoodNumber,
            modelName:
                "Chilton–Colburn j-factor analogy",
            frictionFactorConvention:
                "Fanning friction factor; jD = fF / 2"
        )
    }
}
