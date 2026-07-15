import Foundation

enum NusseltTransportRegime:
    Equatable,
    Sendable {

    case belowUnity
    case approximatelyUnity
    case convectionEnhanced

    var description: String {
        switch self {
        case .belowUnity:
            return """
            The selected characteristic scale produces \
            a Nusselt number below unity.
            """

        case .approximatelyUnity:
            return """
            Heat transfer is close to the reference \
            conduction scale.
            """

        case .convectionEnhanced:
            return """
            Convection enhances heat transfer above the \
            reference conduction scale.
            """
        }
    }
}

struct NusseltNumberResult:
    Equatable,
    Sendable {

    let nusseltNumber: Double
    let referenceConductionCoefficient: Double
    let transportRegime: NusseltTransportRegime
}
