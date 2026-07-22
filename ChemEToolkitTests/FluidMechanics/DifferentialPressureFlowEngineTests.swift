import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Differential Pressure Flow Engine")
struct DifferentialPressureFlowEngineTests {
    private let engine =
        DifferentialPressureFlowEngine()

    private let tolerance = 1e-12

    @Test("Solves a Venturi-meter reference case")
    func solvesVenturiReferenceCase()
        throws {

        let result = try engine.solve(
            input: DifferentialPressureFlowInput(
                meterType: .venturi,
                fluidDensity: 1_000,
                upstreamDiameter: 0.1,
                restrictionDiameter: 0.05,
                pressureDifference: 10_000,
                dischargeCoefficient: 0.98
            )
        )

        #expect(
            abs(
                result.volumetricFlowRate
                    - 0.008887616884747667
            ) < tolerance
        )
        #expect(
            abs(
                result.massFlowRate
                    - 8.887616884747667
            ) < tolerance
        )
        #expect(
            abs(result.betaRatio - 0.5)
                < tolerance
        )
    }

    @Test("Solves an orifice-meter reference case")
    func solvesOrificeReferenceCase()
        throws {

        let result = try engine.solve(
            input: DifferentialPressureFlowInput(
                meterType: .orifice,
                fluidDensity: 1_000,
                upstreamDiameter: 0.1,
                restrictionDiameter: 0.05,
                pressureDifference: 10_000,
                dischargeCoefficient: 0.61
            )
        )

        #expect(
            abs(
                result.idealVolumetricFlowRate
                    - 0.009068996821171089
            ) < tolerance
        )
        #expect(
            abs(
                result.volumetricFlowRate
                    - 0.005532088060914364
            ) < tolerance
        )
        #expect(
            abs(
                result.massFlowRate
                    - 5.532088060914364
            ) < tolerance
        )
    }

    @Test("Rejects a restriction diameter equal to the pipe diameter")
    func rejectsInvalidDiameterRatio() {
        let input = DifferentialPressureFlowInput(
            meterType: .venturi,
            fluidDensity: 998,
            upstreamDiameter: 0.1,
            restrictionDiameter: 0.1,
            pressureDifference: 5_000,
            dischargeCoefficient: 0.98
        )

        do {
            _ = try engine.solve(input: input)
            Issue.record(
                "Expected restrictionMustBeSmaller to be thrown."
            )
        } catch let error as DifferentialPressureFlowError {
            guard case .restrictionMustBeSmaller = error else {
                Issue.record(
                    "Expected restrictionMustBeSmaller; received \(error)."
                )
                return
            }
        } catch {
            Issue.record(
                "Expected DifferentialPressureFlowError; received \(error)."
            )
        }
    }
}
