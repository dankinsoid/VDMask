import Foundation

public enum MaskError: Error {
    
		case invalidString(String, message: String)
		case invalidIndex(String.Index, String)
    case countOutOfRange(Int, Range<UInt>)
    case noValidValues
}
