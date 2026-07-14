struct PressureDropResult:
    Equatable,
    Sendable {

    let reynoldsNumber: Double
    let flowRegime: FlowRegime

    let darcyFrictionFactor: Double
    let fanningFrictionFactor: Double
    let relativeRoughness: Double

    let velocityHead: Double
    let headLoss: Double
    let pressureDrop: Double

    let pipeLength: Double

    var pressureDropKilopascals: Double {
        pressureDrop / 1_000
    }

    var pressureGradient: Double {
        pressureDrop / pipeLength
    }

    var headLossPerUnitLength: Double {
        headLoss / pipeLength
    }
}
