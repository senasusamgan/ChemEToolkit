struct MembraneReactorInput:
    Equatable,
    Sendable {

    let inletConcentrationA: Double
    let inletConcentrationB: Double

    let forwardRateConstant: Double
    let reverseRateConstant: Double
    let membraneRemovalConstant:
        Double

    let spaceTime: Double
}
