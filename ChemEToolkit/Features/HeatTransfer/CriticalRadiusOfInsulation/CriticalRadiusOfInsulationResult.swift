import Foundation

enum CriticalRadiusRegime:
    Equatable,
    Sendable {

    case criticalRadiusInsideOriginalSurface
    case belowCriticalRadius
    case atCriticalRadius
    case aboveCriticalRadius

    var description: String {
        switch self {
        case .criticalRadiusInsideOriginalSurface:
            return """
            Critical radius lies inside the original \
            surface. Additional insulation reduces heat \
            transfer.
            """

        case .belowCriticalRadius:
            return """
            Current outer radius is below the critical \
            radius. Adding insulation may initially \
            increase heat transfer.
            """

        case .atCriticalRadius:
            return """
            Current outer radius is approximately equal \
            to the critical radius and heat transfer is \
            near its maximum.
            """

        case .aboveCriticalRadius:
            return """
            Current outer radius is above the critical \
            radius. Additional insulation reduces heat \
            transfer.
            """
        }
    }
}

struct CriticalRadiusOfInsulationResult:
    Equatable,
    Sendable {

    let criticalRadius: Double

    let conductionResistance: Double
    let convectionResistance: Double
    let totalThermalResistance: Double

    let currentHeatTransferRate: Double

    let maximumHeatTransferRadius: Double
    let maximumHeatTransferRate: Double

    let temperatureDifference: Double
    let regime: CriticalRadiusRegime
}
