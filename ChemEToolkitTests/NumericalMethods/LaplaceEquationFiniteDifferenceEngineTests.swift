import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Laplace Equation Finite Difference Engine") struct LaplaceEquationFiniteDifferenceEngineTests{
 @Test("Preserves equal boundaries")func reference()throws{let r=try LaplaceEquationFiniteDifferenceEngine().solve(.init(rows:7,columns:7,topBoundary:25,bottomBoundary:25,leftBoundary:25,rightBoundary:25));#expect(r.field.flatMap{$0}.allSatisfy{abs($0-25)<1e-12})}
 @Test("A hotter top boundary raises the interior")func trend()throws{let e=LaplaceEquationFiniteDifferenceEngine();let cold=try e.solve(.init(rows:9,columns:9,topBoundary:0,bottomBoundary:0,leftBoundary:0,rightBoundary:0));let hot=try e.solve(.init(rows:9,columns:9,topBoundary:100,bottomBoundary:0,leftBoundary:0,rightBoundary:0));#expect(hot.field[4][4]>cold.field[4][4])}
 @Test("Rejects small grid")func invalid(){#expect(throws:LaplaceEquationFiniteDifferenceError.invalidGrid){try LaplaceEquationFiniteDifferenceEngine().solve(.init(rows:2,columns:5,topBoundary:0,bottomBoundary:0,leftBoundary:0,rightBoundary:0))}}
}
