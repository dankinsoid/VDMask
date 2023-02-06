import Foundation

public protocol MaskComponent<MaskOutput> {
    
    associatedtype MaskOutput
    
    var mask: Mask<MaskOutput> { get }
}

public protocol CustomMaskComponent<MaskOutput>: MaskComponent {
    
    var editableCharacters: CharacterSet { get }
    var fixedCharacters: CharacterSet { get }
    func pattern(placeholder: Character) -> String?
    
    func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet
    func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput
}

public extension CustomMaskComponent {
    
    var mask: Mask<MaskOutput> {
        Mask(self)
    }
}
