import Foundation

struct SegregationModelConversionEngine:
    Sendable {

    private let firstOrderTolerance =
        1.0e-10

    func calculate(
        _ input:
            SegregationModelConversionInput
    ) throws
        -> SegregationModelConversionResult {

        guard
            input.initialConcentrationA.isFinite,
            input.rateConstant.isFinite,
            input.reactionOrder.isFinite,
            input.times.allSatisfy(\.isFinite),
            input.eValues
                .allSatisfy(\.isFinite)
        else {
            throw SegregationModelConversionError
                .nonFiniteInput
        }

        guard input.initialConcentrationA > 0 else {
            throw SegregationModelConversionError
                .nonPositiveInitialConcentration
        }

        guard input.rateConstant > 0 else {
            throw SegregationModelConversionError
                .nonPositiveRateConstant
        }

        guard
            input.reactionOrder >= 0,
            input.reactionOrder <= 3
        else {
            throw SegregationModelConversionError
                .reactionOrderOutOfRange
        }

        guard
            input.times.count
            == input.eValues.count
        else {
            throw SegregationModelConversionError
                .mismatchedArrays
        }

        guard input.times.count >= 2 else {
            throw SegregationModelConversionError
                .insufficientData
        }

        guard
            input.times
                .allSatisfy({
                    $0 >= 0
                })
        else {
            throw SegregationModelConversionError
                .negativeTime
        }

        guard
            zip(
                input.times,
                input.times.dropFirst()
            )
            .allSatisfy({
                $0 < $1
            })
        else {
            throw SegregationModelConversionError
                .nonIncreasingTime
        }

        guard
            input.eValues
                .allSatisfy({
                    $0 >= 0
                })
        else {
            throw SegregationModelConversionError
                .negativeEValue
        }

        func integrate(
            _ values: [Double]
        ) -> Double {
            var total = 0.0

            for index in 0..<(input.times.count - 1) {
                total +=
                    0.5
                    * (
                        values[index]
                        + values[index + 1]
                    )
                    * (
                        input.times[index + 1]
                        - input.times[index]
                    )
            }

            return total
        }

        let rawArea =
            integrate(
                input.eValues
            )

        guard rawArea > 0 else {
            throw SegregationModelConversionError
                .zeroRTDArea
        }

        let normalizedE =
            input.eValues.map {
                $0 / rawArea
            }

        func batchConcentration(
            at time: Double
        ) -> Double {
            if abs(
                input.reactionOrder - 1
            ) <= firstOrderTolerance {
                return input.initialConcentrationA
                * exp(
                    -input.rateConstant
                    * time
                )
            }

            let base =
                pow(
                    input.initialConcentrationA,
                    1 - input.reactionOrder
                )
                + (
                    input.reactionOrder - 1
                )
                * input.rateConstant
                * time

            if base <= 0 {
                return 0
            }

            return pow(
                base,
                1
                / (
                    1 - input.reactionOrder
                )
            )
        }

        let batchConcentrations =
            input.times.map {
                batchConcentration(
                    at: $0
                )
            }

        let concentrationIntegrand =
            zip(
                batchConcentrations,
                normalizedE
            )
            .map(*)

        let outletConcentration =
            integrate(
                concentrationIntegrand
            )

        let conversion =
            1
            - outletConcentration
            / input.initialConcentrationA

        let meanTime =
            integrate(
                zip(
                    input.times,
                    normalizedE
                )
                .map(*)
            )

        let pfrConcentration =
            batchConcentration(
                at: meanTime
            )

        let pfrConversion =
            1
            - pfrConcentration
            / input.initialConcentrationA

        let conversionDifference =
            conversion
            - pfrConversion

        let scalarResults = [
            rawArea,
            meanTime,
            outletConcentration,
            conversion,
            pfrConcentration,
            pfrConversion,
            conversionDifference
        ]

        guard
            scalarResults
                .allSatisfy(\.isFinite),
            batchConcentrations
                .allSatisfy(\.isFinite),
            meanTime >= 0,
            outletConcentration >= 0,
            outletConcentration
                <= input.initialConcentrationA,
            conversion >= 0,
            conversion <= 1,
            pfrConcentration >= 0,
            pfrConcentration
                <= input.initialConcentrationA,
            pfrConversion >= 0,
            pfrConversion <= 1
        else {
            throw SegregationModelConversionError
                .numericalFailure
        }

        return .init(
            rawRTDArea:
                rawArea,
            meanResidenceTime:
                meanTime,
            outletConcentrationA:
                outletConcentration,
            conversionFraction:
                conversion,
            batchConcentrations:
                batchConcentrations,
            equivalentPFRConcentration:
                pfrConcentration,
            equivalentPFRConversion:
                pfrConversion,
            conversionDifferenceFromPFR:
                conversionDifference,
            modelName:
                "Segregation-model conversion for power-law batch kinetics −r_A = kC_Aⁿ",
            limitationDescription:
                "Each fluid element is treated as an isolated constant-volume batch reactor for its residence time. The implementation supports irreversible power-law orders from zero through three and normalizes the supplied RTD."
        )
    }
}
