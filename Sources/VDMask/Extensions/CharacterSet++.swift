import Foundation

extension CharacterSet {
    
    public static var any: CharacterSet {
        CharacterSet().inverted
    }
    
    func isExactly(_ character: Character) -> Bool {
        self == CharacterSet(charactersIn: "\(character)")
    }
    
    func contains(_ character: Character) -> Bool {
        CharacterSet(charactersIn: "\(character)").isSuperset(of: self)
    }
}

public func ...(_ lhs: Unicode.Scalar, _ rhs: Unicode.Scalar) -> CharacterSet {
    CharacterSet(charactersIn: lhs..<rhs).union(CharacterSet([rhs]))
}
