import SwiftUI

struct ModuleRegistry {

    let modules: [AppModule]

    var allModules: [AppModule] {
        modules.sorted {
            if $0.metadata.category.sortOrder ==
                $1.metadata.category.sortOrder {

                return $0.metadata.title <
                    $1.metadata.title
            }

            return $0.metadata.category.sortOrder <
                $1.metadata.category.sortOrder
        }
    }

    var featuredModules: [AppModule] {
        allModules.filter {
            $0.metadata.isFeatured
        }
    }

    var availableCategories:
        [ModuleCategory] {

        let registeredCategories = Set(
            modules.map {
                $0.metadata.category
            }
        )

        return ModuleCategory.allCases
            .filter {
                registeredCategories.contains(
                    $0
                )
            }
            .sorted {
                $0.sortOrder <
                    $1.sortOrder
            }
    }

    func module(
        for id: ModuleID
    ) -> AppModule? {

        modules.first {
            $0.id == id
        }
    }

    func modules(
        in category: ModuleCategory
    ) -> [AppModule] {

        allModules.filter {
            $0.metadata.category ==
                category
        }
    }

    func search(
        for searchText: String
    ) -> [AppModule] {

        allModules.filter {
            $0.metadata.matches(
                searchText: searchText
            )
        }
    }
}

// MARK: - Live Registry

extension ModuleRegistry {

    static let live = ModuleRegistry(
        modules: [
            UnitConverterModule.module,
            IdealGasModule.module,
            SolutionConcentrationModule.module,
            MassBalanceModule.module,
            ReactorDesignModule.module,
            ReactorComparisonModule.module,

            ReynoldsNumberModule.module,
            BernoulliModule.module,
            FlowRateModule.module,
            FrictionFactorModule.module,
            PressureDropModule.module,
            MinorLossModule.module,
            PumpPowerModule.module,
            HydrostaticPressureModule.module,
            ManometerModule.module,
            TankDrainModule.module,
            OpenChannelModule.module,
            FroudeNumberModule.module,
            CriticalDepthModule.module,
            DragForceModule.module,
            ParticleSettlingModule.module,
            VenturiMeterModule.module,
            OrificeMeterModule.module,

            NumericalIntegrationModule.module,
            NumericalInterpolationModule.module,
            NumericalDifferentiationModule.module,
            RootFindingModule.module,
            LinearSystemModule.module,
            ODESolverModule.module,
            CurveFittingModule.module
        ]
    )
}
