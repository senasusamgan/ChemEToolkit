struct CriticalDepthResult:
    Equatable,
    Sendable {

    let criticalDepth: Double
    let criticalVelocity: Double
    let minimumSpecificEnergy: Double

    let currentDepth: Double
    let currentVelocity: Double
    let currentSpecificEnergy: Double
    let currentFroudeNumber: Double

    let flowRegime:
        OpenChannelFlowRegime

    let volumetricFlowRate: Double
    let channelWidth: Double

    var depthDifference: Double {
        currentDepth - criticalDepth
    }

    var energyAboveMinimum: Double {
        currentSpecificEnergy
        - minimumSpecificEnergy
    }
}
