enum AdsorptionIsothermModel:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case langmuir
    case freundlich
    case linear

    var id: Self { self }

    var title: String {
        switch self {
        case .langmuir:
            return "Langmuir"

        case .freundlich:
            return "Freundlich"

        case .linear:
            return "Linear"
        }
    }
}

struct AdsorptionIsothermsInput:
    Equatable,
    Sendable {

    let model: AdsorptionIsothermModel
    let equilibriumFluidConcentration: Double

    let maximumAdsorptionCapacity: Double
    let langmuirConstant: Double

    let freundlichConstant: Double
    let freundlichExponent: Double

    let linearDistributionConstant: Double
}
