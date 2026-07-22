import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Ridders Root Finder Engine") struct RiddersRootFinderEngineTests{
 @Test("Finds the cubic reference root")func reference()throws{let r=try RiddersRootFinderEngine().solve(.init(function:.cubic,lowerBound:1,upperBound:2));#expect(abs(r.root-1.52137970680457)<1e-9)}
 @Test("Tighter tolerance reduces residual")func trend()throws{let e=RiddersRootFinderEngine();let loose=try e.solve(.init(function:.exponentialBalance,lowerBound:0,upperBound:1,tolerance:1e-5));let tight=try e.solve(.init(function:.exponentialBalance,lowerBound:0,upperBound:1,tolerance:1e-12));#expect(abs(tight.functionValue)<=abs(loose.functionValue))}
 @Test("Rejects an unbracketed root")func invalid(){#expect(throws:RiddersRootFinderError.rootNotBracketed){try RiddersRootFinderEngine().solve(.init(function:.cubic,lowerBound:2,upperBound:3))}}
}
