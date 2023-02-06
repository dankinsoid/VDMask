import Foundation

public struct Constant<MaskOutput>: CustomMaskComponent {
    
    public let value: MaskOutput
    public let string: String
    
    public var editableCharacters: CharacterSet { string.mask.editableCharacters }
    public var fixedCharacters: CharacterSet { string.mask.fixedCharacters }
    
    public init(_ value: MaskOutput, toString: @escaping (MaskOutput) -> String) {
        self.value = value
        self.string = toString(value)
    }
    
    public func allowedCharacters(offset: Int, for input: String, startAt index: String.Index, outOfRange: (Int) -> CharacterSet) -> CharacterSet {
        string.mask.allowedCharacters(offset: offset, for: input, startAt: index, outOfRange: outOfRange)
    }
    
    public func pattern(placeholder: Character) -> String? {
        string.mask.pattern(placeholder: placeholder)
    }
    
    public func output(from input: String, startAt index: inout String.Index) throws -> MaskOutput {
        try string.mask.output(from: input, startAt: &index)
        return value
    }
}

extension Constant where MaskOutput: CustomStringConvertible {
    
    public init(_ value: MaskOutput) {
        self.init(value, toString: \.description)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension Constant {
    
    public init<Format: FormatStyle>(_ value: MaskOutput, format: Format) where Format.FormatInput == MaskOutput, Format.FormatOutput == String {
        self.init(value, toString: format.format)
    }
}
