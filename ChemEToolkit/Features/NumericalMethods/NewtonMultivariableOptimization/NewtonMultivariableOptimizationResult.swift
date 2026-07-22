struct NewtonMultivariableOptimizationResult: Equatable, Sendable { let optimum:[Double]; let objectiveValue:Double; let gradientNorm:Double; let iterations:Int }
