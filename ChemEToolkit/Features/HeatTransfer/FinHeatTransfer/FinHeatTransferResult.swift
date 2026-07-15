import Foundation

struct FinHeatTransferResult:
    Equatable,
    Sendable {

    let crossSectionalArea: Double
    let perimeter: Double
    let finSurfaceArea: Double

    /// m = sqrt(hP / kAc), 1/m.
    let finParameter: Double

    /// Dimensionless fin parameter, mL.
    let dimensionlessFinParameter: Double

    /// Heat-transfer rate from an adiabatic-tip fin, W.
    let heatTransferRate: Double

    /// Actual heat transfer divided by maximum possible
    /// fin-surface heat transfer.
    let finEfficiency: Double

    /// Fin heat transfer divided by heat transfer from
    /// the exposed base cross-sectional area.
    let finEffectiveness: Double

    let temperatureDifference: Double
}
