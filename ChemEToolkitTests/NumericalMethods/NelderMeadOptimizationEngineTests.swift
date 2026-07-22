import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Nelder-Mead Optimization Engine") struct NelderMeadOptimizationEngineTests{
 @Test("Finds the quadratic minimum")func reference()throws{let r=try NelderMeadOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0,0]));#expect(abs(r.optimum[0]-2)<1e-5);#expect(abs(r.optimum[1]+1)<1e-5)}
 @Test("Rosenbrock objective decreases")func trend()throws{let r=try NelderMeadOptimizationEngine().solve(.init(objective:.rosenbrock,initialPoint:[-1.2,1],initialStep:0.5,tolerance:1e-8,maximumIterations:2000));#expect(r.objectiveValue<1e-6)}
 @Test("Rejects a one-dimensional point")func invalid(){#expect(throws:NelderMeadOptimizationError.invalidInitialPoint){try NelderMeadOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0]))}}
}
