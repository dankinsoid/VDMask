import Foundation

public struct SequenceMask<First, Second, MaskOutput>: CustomMaskComponent {
    
    public let first: Mask<First>
    public let second: Mask<Second>
    public let map: (First, Second) throws -> MaskOutput
    
    public var fixedCharacters: CharacterSet {
        first.fixedCharacters.union(second.fixedCharacters)
    }
    public var editableCharacters: CharacterSet {
        first.editableCharacters.union(second.editableCharacters)
    }
    
    public init(
        first: some MaskComponent<First>,
        second: some MaskComponent<Second>,
        map: @escaping (First, Second) -> MaskOutput
    ) {
        self.first = first.mask
        self.second = second.mask
        self.map = map
    }
    
    public func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
        first.allowedCharacters(offset: offset, for: input, startAt: index) { offset in
            second.allowedCharacters(offset: offset, for: input, startAt: index, outOfRange: outOfRange)
        }
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput {
        let firstOutput = try first.output(from: input, startAt: &index)
        let secondOutput = try second.output(from: input, startAt: &index)
        return try map(firstOutput, secondOutput)
    }
    
    public func pattern(placeholder: Character) -> String? {
        guard
            let left = first.pattern(placeholder: placeholder),
            let right = second.pattern(placeholder: placeholder)
        else {
            return nil
        }
        return "\(left)\(right)"
    }
}
