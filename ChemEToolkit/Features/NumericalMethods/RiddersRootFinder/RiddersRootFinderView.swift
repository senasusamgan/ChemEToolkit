import Foundation
import SwiftUI
struct RiddersRootFinderView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Ridders Root Finder").font(.largeTitle.bold())
  Text("Bracketed root of x³ − x − 2 on [1, 2].").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r = try RiddersRootFinderEngine().solve(.init(function: .cubic, lowerBound: 1, upperBound: 2)); output = String(format: "%.10g", r.root);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
