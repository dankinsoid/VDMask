import Foundation

public struct EmptyMask: CustomMaskComponent {
    
    public typealias MaskOutput = Void
    
    public var editableCharacters: CharacterSet { CharacterSet() }
    public var fixedCharacters: CharacterSet { CharacterSet() }
    
    public init() {
    }
    
    public func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
        outOfRange(offset)
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws {
    }
    
    public func pattern(placeholder: Character) -> String? {
        ""
    }
}
