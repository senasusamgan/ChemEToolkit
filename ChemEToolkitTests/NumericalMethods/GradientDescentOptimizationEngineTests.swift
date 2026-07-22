import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Gradient Descent Optimization Engine") struct GradientDescentOptimizationEngineTests{
 @Test("Finds the quadratic minimum")func reference()throws{let r=try GradientDescentOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0,0]));#expect(abs(r.optimum[0]-2)<1e-7);#expect(abs(r.optimum[1]+1)<1e-7)}
 @Test("Rosenbrock objective decreases")func trend()throws{let r=try GradientDescentOptimizationEngine().solve(.init(objective:.rosenbrock,initialPoint:[-1.2,1],initialStep:0.001,tolerance:1e-5,maximumIterations:50000));#expect(r.objectiveValue<1e-5)}
 @Test("Rejects wrong dimension")func invalid(){#expect(throws:GradientDescentOptimizationError.invalidInitialPoint){try GradientDescentOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0]))}}
}
