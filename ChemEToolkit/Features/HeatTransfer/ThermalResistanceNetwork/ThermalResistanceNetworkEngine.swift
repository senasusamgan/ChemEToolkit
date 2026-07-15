import Foundation

struct ThermalResistanceNetworkEngine {

    func calculate(
        input: ThermalResistanceNetworkInput
    ) throws -> ThermalResistanceNetworkResult {

        try validate(input)

        let temperatureDifference =
            input.hotSideTemperature
            - input.coldSideTemperature

        switch input.arrangement {
        case .series:
            return calculateSeries(
                resistances: input.resistances,
                temperatureDifference:
                    temperatureDifference
            )

        case .parallel:
            return calculateParallel(
                resistances: input.resistances,
                temperatureDifference:
                    temperatureDifference
            )
        }
    }

    private func calculateSeries(
        resistances: [Double],
        temperatureDifference: Double
    ) -> ThermalResistanceNetworkResult {

        let equivalentResistance =
            resistances.reduce(0, +)

        let heatTransferRate =
            temperatureDifference
            / equivalentResistance

        let branches =
            resistances.enumerated().map {
                index,
                resistance in

                ThermalResistanceBranchResult(
                    branchNumber: index + 1,
                    resistance: resistance,
                    heatTransferRate:
                        heatTransferRate,
                    temperatureDrop:
                        heatTransferRate
                        * resistance
                )
            }

        return ThermalResistanceNetworkResult(
            arrangement: .series,
            equivalentResistance:
                equivalentResistance,
            totalHeatTransferRate:
                heatTransferRate,
            temperatureDifference:
                temperatureDifference,
            branchResults: branches
        )
    }

    private func calculateParallel(
        resistances: [Double],
        temperatureDifference: Double
    ) -> ThermalResistanceNetworkResult {

        let conductance =
            resistances.reduce(0) {
                partial,
                resistance in

                partial + 1 / resistance
            }

        let equivalentResistance =
            1 / conductance

        let branches =
            resistances.enumerated().map {
                index,
                resistance in

                ThermalResistanceBranchResult(
                    branchNumber: index + 1,
                    resistance: resistance,
                    heatTransferRate:
                        temperatureDifference
                        / resistance,
                    temperatureDrop:
                        temperatureDifference
                )
            }

        let totalHeatTransferRate =
            branches.reduce(0) {
                $0 + $1.heatTransferRate
            }

        return ThermalResistanceNetworkResult(
            arrangement: .parallel,
            equivalentResistance:
                equivalentResistance,
            totalHeatTransferRate:
                totalHeatTransferRate,
            temperatureDifference:
                temperatureDifference,
            branchResults: branches
        )
    }

    private func validate(
        _ input: ThermalResistanceNetworkInput
    ) throws {

        let values = [
            input.hotSideTemperature,
            input.coldSideTemperature
        ] + input.resistances

        guard values.allSatisfy(\.isFinite) else {
            throw ThermalResistanceNetworkError
                .nonFiniteInput
        }

        guard !input.resistances.isEmpty else {
            throw ThermalResistanceNetworkError
                .noResistances
        }

        for (
            index,
            resistance
        ) in input.resistances.enumerated() {
            guard resistance > 0 else {
                throw ThermalResistanceNetworkError
                    .nonPositiveResistance(
                        branchNumber: index + 1
                    )
            }
        }

        guard
            input.hotSideTemperature
                >= input.coldSideTemperature
        else {
            throw ThermalResistanceNetworkError
                .invalidTemperatureOrder
        }
    }
}
