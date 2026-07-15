import Foundation

enum PrandtlTransportRegime:
    Equatable,
    Sendable {

    case thermalDiffusionDominant
    case comparableDiffusion
    case momentumDiffusionDominant

    var description: String {
        switch self {
        case .thermalDiffusionDominant:
            return """
            Thermal diffusivity is much greater than \
            momentum diffusivity.
            """

        case .comparableDiffusion:
            return """
            Momentum and thermal diffusion occur on \
            comparable scales.
            """

        case .momentumDiffusionDominant:
            return """
            Momentum diffusivity is much greater than \
            thermal diffusivity.
            """
        }
    }
}

struct PrandtlNumberResult:
    Equatable,
    Sendable {

    let prandtlNumber: Double
    let transportRegime: PrandtlTransportRegime
}
