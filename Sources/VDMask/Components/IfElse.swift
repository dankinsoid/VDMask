import Foundation

public enum IfElse<If, Else> {
    
    case `if`(If)
    case `else`(Else)
    
    public var `if`: If? {
        switch self {
        case .if(let value):
            return value
        case .else:
            return nil
        }
    }
    
    public var `else`: Else? {
        switch self {
        case .if:
            return nil
        case .else(let value):
            return value
        }
    }
}

extension IfElse: MaskComponent where If: MaskComponent, Else: MaskComponent {
    
    public var mask: Mask<IfElse<If.MaskOutput, Else.MaskOutput>> {
        switch self {
        case .if(let first):
            return first.mask.map { .if($0) }
        case .else(let second):
            return second.mask.map { .else($0) }
        }
    }
}
