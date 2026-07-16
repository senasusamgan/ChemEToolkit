struct ECurveGeneratorInput:
    Equatable,
    Sendable {

    let times: [Double]
    let tracerConcentrations: [Double]
}
