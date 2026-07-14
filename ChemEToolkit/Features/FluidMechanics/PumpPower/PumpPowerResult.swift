struct PumpPowerResult:
    Equatable,
    Sendable {

    let pressureIncrease: Double
    let hydraulicPower: Double
    let shaftPower: Double

    let volumetricFlowRate: Double
    let pumpHead: Double
    let efficiency: Double

    var pressureIncreaseKilopascals:
        Double {
        pressureIncrease / 1_000
    }

    var hydraulicPowerKilowatts:
        Double {
        hydraulicPower / 1_000
    }

    var shaftPowerKilowatts:
        Double {
        shaftPower / 1_000
    }

    var powerLoss: Double {
        shaftPower - hydraulicPower
    }

    var powerLossKilowatts: Double {
        powerLoss / 1_000
    }
}
