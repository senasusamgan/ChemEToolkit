import Foundation

enum NaturalConvectionBuoyancyDirection:
    Equatable,
    Sendable {

    case heatedSurface
    case cooledSurface
    case noTemperatureDifference

    var description: String {
        switch self {
        case .heatedSurface:
            return "Surface is hotter than the fluid."

        case .cooledSurface:
            return "Surface is colder than the fluid."

        case .noTemperatureDifference:
            return "No thermal buoyancy temperature difference."
        }
    }
}

struct GrashofNumberResult:
    Equatable,
    Sendable {

    let grashofNumber: Double
    let temperatureDifferenceMagnitude: Double
    let buoyancyDirection:
        NaturalConvectionBuoyancyDirection
}
