import Foundation

enum ConcentrationMode: String, CaseIterable, Identifiable, Codable, Hashable {
    case molarity
    case molality

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .molarity:
            return "Molarity"

        case .molality:
            return "Molality"
        }
    }

    var symbol: String {
        switch self {
        case .molarity:
            return "M"

        case .molality:
            return "m"
        }
    }

    var formula: String {
        switch self {
        case .molarity:
            return "M = n / V"

        case .molality:
            return "m = n / mₛ"
        }
    }

    var concentrationUnit: String {
        switch self {
        case .molarity:
            return "mol/L"

        case .molality:
            return "mol/kg"
        }
    }

    var denominatorName: String {
        switch self {
        case .molarity:
            return "Solution Volume"

        case .molality:
            return "Solvent Mass"
        }
    }

    var denominatorSymbol: String {
        switch self {
        case .molarity:
            return "V"

        case .molality:
            return "mₛ"
        }
    }

    var denominatorUnit: String {
        switch self {
        case .molarity:
            return "L"

        case .molality:
            return "kg"
        }
    }

    var explanation: String {
        switch self {
        case .molarity:
            return "Moles of solute per liter of solution"

        case .molality:
            return "Moles of solute per kilogram of solvent"
        }
    }

    var icon: String {
        switch self {
        case .molarity:
            return "flask.fill"

        case .molality:
            return "scalemass.fill"
        }
    }
}

enum ConcentrationUnknown: String, CaseIterable, Identifiable, Codable, Hashable {
    case concentration
    case moles
    case denominator

    var id: String {
        rawValue
    }

    func symbol(
        for mode: ConcentrationMode
    ) -> String {
        switch self {
        case .concentration:
            return mode.symbol

        case .moles:
            return "n"

        case .denominator:
            return mode.denominatorSymbol
        }
    }

    func label(
        for mode: ConcentrationMode
    ) -> String {
        switch self {
        case .concentration:
            return mode.title

        case .moles:
            return "Amount of Solute"

        case .denominator:
            return mode.denominatorName
        }
    }

    func unit(
        for mode: ConcentrationMode
    ) -> String {
        switch self {
        case .concentration:
            return mode.concentrationUnit

        case .moles:
            return "mol"

        case .denominator:
            return mode.denominatorUnit
        }
    }
}

struct ConcentrationInput: Equatable {
    let concentration: Double?
    let moles: Double?
    let denominator: Double?
}

struct ConcentrationResult: Equatable {
    let mode: ConcentrationMode
    let variable: ConcentrationUnknown
    let value: Double

    var label: String {
        variable.label(for: mode)
    }

    var unit: String {
        variable.unit(for: mode)
    }
}
