import Foundation

enum MethodOfLinesInitialProfile: String, CaseIterable, Equatable, Sendable {
    case uniform
    case sinePulse
}

struct MethodOfLinesPDESolverInput: Equatable, Sendable {
    let diffusivity: Double
    let reactionRateConstant: Double
    let length: Double
    let totalTime: Double
    let spatialNodes: Int
    let timeSteps: Int
    let initialConcentration: Double
    let leftBoundaryConcentration: Double
    let rightBoundaryConcentration: Double
    let initialProfile: MethodOfLinesInitialProfile

    init(
        diffusivity: Double,
        reactionRateConstant: Double = 0,
        length: Double,
        totalTime: Double,
        spatialNodes: Int,
        timeSteps: Int,
        initialConcentration: Double,
        leftBoundaryConcentration: Double = 0,
        rightBoundaryConcentration: Double = 0,
        initialProfile: MethodOfLinesInitialProfile = .sinePulse
    ) {
        self.diffusivity = diffusivity
        self.reactionRateConstant = reactionRateConstant
        self.length = length
        self.totalTime = totalTime
        self.spatialNodes = spatialNodes
        self.timeSteps = timeSteps
        self.initialConcentration = initialConcentration
        self.leftBoundaryConcentration = leftBoundaryConcentration
        self.rightBoundaryConcentration = rightBoundaryConcentration
        self.initialProfile = initialProfile
    }
}
