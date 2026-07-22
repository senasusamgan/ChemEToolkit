import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Cubic Hermite Interpolation Engine") struct CubicHermiteInterpolationEngineTests{
 @Test("Exactly reproduces a cubic")func reference()throws{let r=try CubicHermiteInterpolationEngine().solve(.init(x0:0,x1:1,y0:0,y1:1,slope0:0,slope1:3,query:0.5));#expect(abs(r.value-0.125)<1e-12)}
 @Test("Preserves endpoint values")func trend()throws{let e=CubicHermiteInterpolationEngine();let a=try e.solve(.init(x0:0,x1:2,y0:4,y1:9,slope0:1,slope1:2,query:0));let b=try e.solve(.init(x0:0,x1:2,y0:4,y1:9,slope0:1,slope1:2,query:2));#expect(a.value==4);#expect(b.value==9)}
 @Test("Rejects reversed interval")func invalid(){#expect(throws:CubicHermiteInterpolationError.invalidInterval){try CubicHermiteInterpolationEngine().solve(.init(x0:1,x1:0,y0:0,y1:1,slope0:0,slope1:1,query:0.5))}}
}
