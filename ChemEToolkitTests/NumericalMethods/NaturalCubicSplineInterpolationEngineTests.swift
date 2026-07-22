import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Natural Cubic Spline Engine") struct NaturalCubicSplineInterpolationEngineTests{
 @Test("Reproduces linear data")func reference()throws{let r=try NaturalCubicSplineInterpolationEngine().solve(.init(xValues:[0,1,2],yValues:[1,3,5],query:1.5));#expect(abs(r.value-4)<1e-12);#expect(abs(r.firstDerivative-2)<1e-12)}
 @Test("Preserves monotonic trend for reference data")func trend()throws{let e=NaturalCubicSplineInterpolationEngine();let a=try e.solve(.init(xValues:[0,1,2,3],yValues:[0,1,2,3],query:0.5));let b=try e.solve(.init(xValues:[0,1,2,3],yValues:[0,1,2,3],query:2.5));#expect(b.value>a.value)}
 @Test("Rejects repeated x values")func invalid(){#expect(throws:NaturalCubicSplineInterpolationError.nonIncreasingX){try NaturalCubicSplineInterpolationEngine().solve(.init(xValues:[0,1,1],yValues:[0,1,2],query:0.5))}}
}
