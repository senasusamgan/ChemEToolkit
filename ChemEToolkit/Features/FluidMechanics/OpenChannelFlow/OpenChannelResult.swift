struct OpenChannelResult:
    Equatable,
    Sendable {

    let channelWidth: Double
    let flowDepth: Double
    let bedSlope: Double
    let manningCoefficient: Double

    let crossSectionalArea: Double
    let wettedPerimeter: Double
    let hydraulicRadius: Double

    let volumetricFlowRate: Double
    let averageVelocity: Double

    var volumetricFlowRatePerHour:
        Double {
        volumetricFlowRate * 3_600
    }

    var topWidth: Double {
        channelWidth
    }

    var hydraulicDepth: Double {
        crossSectionalArea / topWidth
    }
}
