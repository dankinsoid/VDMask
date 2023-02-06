import Foundation

public struct MaskFormatOptions: OptionSet {
    
    public var rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public extension MaskFormatOptions {
    
    static var `default`: MaskFormatOptions = [.autocomplete]
    
    static var autocomplete: MaskFormatOptions { MaskFormatOptions(rawValue: 1) }
}
