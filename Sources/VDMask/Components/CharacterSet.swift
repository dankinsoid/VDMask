import Foundation

extension CharacterSet: MaskComponent {
    
    @MaskBuilder
    public var mask: Mask<Character> {
        MaskComponent(self)
    }
    
    private struct MaskComponent: CustomMaskComponent {
        
        typealias MaskOutput = Character
        
        let editableCharacters: CharacterSet
        var fixedCharacters: CharacterSet { CharacterSet() }
        
        init(_ set: CharacterSet) {
            editableCharacters = set
        }
        func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
            guard offset == 0 else {
                return outOfRange(offset - 1)
            }
            return editableCharacters
        }
        
        func output(from input: String, startAt index: inout String.Index) throws -> Character {
            guard input.indices.contains(index) else {
                throw MaskError.invalidIndex(index, input)
            }
            guard editableCharacters.contains(input[index]) else {
                throw MaskError.invalidString(
                    input,
                    message: "Character '\(input[index])' doesn't allowed at \(input.distance(from: input.startIndex, to: index)) offset"
                )
            }
            let result = input[index]
            index = input.index(after: index)
            return result
        }
        
        func pattern(placeholder: Character) -> String? {
            String(placeholder)
        }
    }
}
