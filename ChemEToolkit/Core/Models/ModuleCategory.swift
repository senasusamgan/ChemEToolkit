import Foundation

enum ModuleCategory: String, CaseIterable, Codable, Hashable, Identifiable {
    case engineeringFundamentals
    case materialAndEnergyBalances
    case thermodynamics
    case fluidMechanics
    case heatTransfer
    case massTransfer
    case reactionEngineering
    case processControl
    case numericalMethods
    case processSafetyAndEconomics
    case separationProcesses

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .engineeringFundamentals:
            return "Engineering Fundamentals"

        case .materialAndEnergyBalances:
            return "Material & Energy Balances"

        case .thermodynamics:
            return "Thermodynamics"

        case .fluidMechanics:
            return "Fluid Mechanics"

        case .heatTransfer:
            return "Heat Transfer"

        case .massTransfer:
            return "Mass Transfer"

        case .reactionEngineering:
            return "Reaction Engineering"

        case .processControl:
            return "Process Control"

        case .numericalMethods:
            return "Numerical Methods"

        case .processSafetyAndEconomics:
            return "Process Safety & Economics"
                    case .separationProcesses:
                return "Separation Processes"
}
    }

    var subtitle: String {
        switch self {
        case .engineeringFundamentals:
            return "Units, dimensions and essential engineering tools"

        case .materialAndEnergyBalances:
            return "Material flows, balances and process calculations"

        case .thermodynamics:
            return "Gas laws, properties and phase behavior"

        case .fluidMechanics:
            return "Flow, pressure drop and transport in pipes"

        case .heatTransfer:
            return "Conduction, convection and heat exchangers"

        case .massTransfer:
            return "Diffusion and separation processes"

        case .reactionEngineering:
            return "Reaction kinetics and reactor design"

        case .processControl:
            return "Dynamic systems and process controllers"

        case .numericalMethods:
            return "Integration, root finding and numerical solutions"

        case .processSafetyAndEconomics:
            return "Safety analysis and economic evaluation"
                    case .separationProcesses:
                return "Distillation, absorption, extraction, membranes and drying"
}
    }

    var symbolName: String {
        switch self {
        case .engineeringFundamentals:
            return "ruler"

        case .materialAndEnergyBalances:
            return "arrow.triangle.2.circlepath"

        case .thermodynamics:
            return "thermometer.medium"

        case .fluidMechanics:
            return "drop.fill"

        case .heatTransfer:
            return "flame.fill"

        case .massTransfer:
            return "aqi.medium"

        case .reactionEngineering:
            return "atom"

        case .processControl:
            return "slider.horizontal.3"

        case .numericalMethods:
            return "function"

        case .processSafetyAndEconomics:
            return "shield.checkered"
                    case .separationProcesses:
                return "arrow.triangle.branch"
}
    }

    var sortOrder: Int {
        switch self {
        case .engineeringFundamentals:
            return 0
        case .materialAndEnergyBalances:
            return 1
        case .thermodynamics:
            return 2
        case .fluidMechanics:
            return 3
        case .heatTransfer:
            return 4
        case .massTransfer:
            return 5
        case .reactionEngineering:
            return 6
        case .processControl:
            return 7
        case .numericalMethods:
            return 8
        case .processSafetyAndEconomics:
            return 9
                    case .separationProcesses:
                return 10
}
    }
}
