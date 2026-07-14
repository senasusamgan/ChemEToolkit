struct BernoulliResult:
    Equatable,
    Sendable {

    let inletPressure: Double
    let outletPressure: Double

    let inletPressureHead: Double
    let inletVelocityHead: Double
    let inletElevationHead: Double

    let outletPressureHead: Double
    let outletVelocityHead: Double
    let outletElevationHead: Double

    let pumpHead: Double
    let turbineHead: Double
    let headLoss: Double

    let inletTotalHead: Double
    let outletTotalHead: Double

    var pressureChange: Double {
        outletPressure -
            inletPressure
    }

    var elevationChange: Double {
        outletElevationHead -
            inletElevationHead
    }

    var velocityHeadChange: Double {
        outletVelocityHead -
            inletVelocityHead
    }
}
