struct CSTRPFRSequenceInput:
    Equatable,
    Sendable {

    let inletConcentration: Double
    let volumetricFlowRate: Double

    let cstrVolume: Double
    let cstrRateConstant: Double

    let pfrVolume: Double
    let pfrRateConstant: Double
}
