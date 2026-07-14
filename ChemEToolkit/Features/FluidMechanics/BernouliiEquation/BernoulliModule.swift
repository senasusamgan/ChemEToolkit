import SwiftUI

enum BernoulliModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .bernoulliEquation,
            title:
                "Bernoulli Equation & Energy Head",
            subtitle:
                "Calculate pressure changes using the extended energy equation",
            category:
                .fluidMechanics,
            symbolName:
                "arrow.left.arrow.right.circle.fill",
            keywords: [
                "Bernoulli equation",
                "energy equation",
                "energy head",
                "pressure head",
                "velocity head",
                "elevation head",
                "pump head",
                "turbine head",
                "head loss",
                "outlet pressure",
                "fluid mechanics",
                "pipe flow"
            ]
        ),
        destination: {
            BernoulliView()
        }
    )
}
