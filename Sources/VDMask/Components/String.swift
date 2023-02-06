import Foundation

extension String: MaskComponent {
    
    @MaskBuilder
    public var mask: Mask<Void> {
        MaskComponent(string: self)
    }
    
    private struct MaskComponent: CustomMaskComponent {
        
        typealias MaskOutput = Void
        
        let string: String
        
        var fixedCharacters: CharacterSet {
            CharacterSet(charactersIn: string)
        }
        
        var editableCharacters: CharacterSet {
            CharacterSet()
        }
        
        func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
            guard offset < string.count, offset >= 0 else {
                return outOfRange(offset - string.count)
            }
            let result = CharacterSet(charactersIn: String(string[string.index(string.startIndex, offsetBy: offset)]))
            return result
        }
        
        func output(from input: String, startAt index: inout String.Index) throws -> Void {
            ()
        }
        
        func pattern(placeholder: Character) -> String? {
            string
        }

    }
}
