import Foundation

struct MurphreeTrayEfficiencyEngine: Sendable {
    func calculate(_ input: MurphreeTrayEfficiencyInput) throws -> MurphreeTrayEfficiencyResult {
        let values = [input.idealStageCount, input.murphreeEfficiency, input.traySpacing, input.columnHeightSafetyFactor]
        guard values.allSatisfy(\.isFinite) else { throw MurphreeTrayEfficiencyError.nonFiniteInput }
        guard input.idealStageCount > 0 else { throw MurphreeTrayEfficiencyError.nonPositiveIdealStages }
        guard input.murphreeEfficiency > 0, input.murphreeEfficiency <= 1 else {
            throw MurphreeTrayEfficiencyError.invalidEfficiency
        }
        guard input.traySpacing > 0 else { throw MurphreeTrayEfficiencyError.nonPositiveTraySpacing }
        guard input.columnHeightSafetyFactor >= 1 else { throw MurphreeTrayEfficiencyError.invalidSafetyFactor }

        let continuous = input.idealStageCount / input.murphreeEfficiency
        let trays = Int(Foundation.ceil(continuous))
        let activeHeight = Double(max(0, trays - 1)) * input.traySpacing
        let designHeight = activeHeight * input.columnHeightSafetyFactor
        let penalty = continuous - input.idealStageCount

        guard [continuous, activeHeight, designHeight, penalty].allSatisfy(\.isFinite) else {
            throw MurphreeTrayEfficiencyError.numericalFailure
        }

        return .init(
            continuousActualStageCount: continuous,
            requiredActualTrays: trays,
            activeTrayHeight: activeHeight,
            designTraySectionHeight: designHeight,
            stagePenalty: penalty,
            modelName: "Overall Murphree tray-efficiency conversion",
            limitationDescription: "Applies a single average efficiency to every ideal stage and estimates active tray height from uniform spacing."
        )
    }
}
