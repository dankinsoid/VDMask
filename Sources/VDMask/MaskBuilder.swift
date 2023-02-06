import Foundation

@resultBuilder
public enum MaskBuilder {
    
    @inlinable
    static func buildBlock() -> Mask<Void> {
        EmptyMask().mask
    }
    
    @inlinable
    public static func buildPartialBlock<Output>(first content: Mask<Output>) ->  Mask<Output> {
        content
    }
    
    @inlinable
    public static func buildPartialBlock<Output>(accumulated: Mask<Output>, next: Mask<Void>) -> Mask<Output> {
        SequenceMask(first: accumulated, second: next, map: { output, _ in output }).mask
    }
    
    @inlinable
    public static func buildPartialBlock<Output>(accumulated: Mask<Void>, next: Mask<Output>) -> Mask<Output> {
        SequenceMask(first: accumulated, second: next, map: { _, output in output }).mask
    }
    
    @inlinable
    static func buildPartialBlock(accumulated: Mask<Void>, next: Mask<Void>) -> Mask<Void> {
        SequenceMask(first: accumulated, second: next, map: { _, _ in () }).mask
    }
    
    //    @inlinable
    //    static func buildPartialBlock<Output: RangeReplaceableCollection>(accumulated: Mask<Output>, next: Mask<Output>) -> Mask<Output> {
    //        Mask(SequenceMask(first: accumulated, second: next, map: +))
    //    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1>(accumulated: Mask<C0>, next: Mask<C1>) -> Mask<(C0, C1)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2>(accumulated: Mask<(C0, C1)>, next: Mask<C2>) -> Mask<(C0, C1, C2)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2>(accumulated: Mask<C0>, next: Mask<(C1, C2)>) -> Mask<(C0, C1, C2)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3>(accumulated: Mask<(C0, C1, C2)>, next: Mask<C3>) -> Mask<(C0, C1, C2, C3)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3)>) -> Mask<(C0, C1, C2, C3)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3)>) -> Mask<(C0, C1, C2, C3)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<C4>) -> Mask<(C0, C1, C2, C3, C4)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4)>) -> Mask<(C0, C1, C2, C3, C4)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4)>) -> Mask<(C0, C1, C2, C3, C4)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4)>) -> Mask<(C0, C1, C2, C3, C4)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5>(accumulated: Mask<(C0, C1, C2, C3, C4)>, next: Mask<C5>) -> Mask<(C0, C1, C2, C3, C4, C5)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<(C4, C5)>) -> Mask<(C0, C1, C2, C3, C4, C5)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4, C5)>) -> Mask<(C0, C1, C2, C3, C4, C5)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4, C5)>) -> Mask<(C0, C1, C2, C3, C4, C5)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4, C5)>) -> Mask<(C0, C1, C2, C3, C4, C5)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3, $1.4) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<(C0, C1, C2, C3, C4, C5)>, next: Mask<C6>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<(C0, C1, C2, C3, C4)>, next: Mask<(C5, C6)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<(C4, C5, C6)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4, C5, C6)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4, C5, C6)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2, $1.3, $1.4) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4, C5, C6)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6)>, next: Mask<C7>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1, C2, C3, C4, C5)>, next: Mask<(C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1, C2, C3, C4)>, next: Mask<(C5, C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<(C4, C5, C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4, C5, C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2, $1.3, $1.4) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4, C5, C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4, C5, C6, C7)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6, C7)>, next: Mask<C8>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6)>, next: Mask<(C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2, C3, C4, C5)>, next: Mask<(C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2, C3, C4)>, next: Mask<(C5, C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<(C4, C5, C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1.0, $1.1, $1.2, $1.3, $1.4) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4, C5, C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4, C5, C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4, C5, C6, C7, C8)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>, next: Mask<C9>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, $1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6, C7)>, next: Mask<(C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $1.0, $1.1) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3, C4, C5, C6)>, next: Mask<(C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $1.0, $1.1, $1.2) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3, C4, C5)>, next: Mask<(C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1.0, $1.1, $1.2, $1.3) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3, C4)>, next: Mask<(C5, C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1.0, $1.1, $1.2, $1.3, $1.4) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2, C3)>, next: Mask<(C4, C5, C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $0.3, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1, C2)>, next: Mask<(C3, C4, C5, C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<(C0, C1)>, next: Mask<(C2, C3, C4, C5, C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0.0, $0.1, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(accumulated: Mask<C0>, next: Mask<(C1, C2, C3, C4, C5, C6, C7, C8, C9)>) -> Mask<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        SequenceMask(first: accumulated, second: next, map: { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7, $1.8) }).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildEither<First, Second>(first component: Mask<First>) -> Mask<IfElse<First, Second>> {
        IfElse<Mask<First>, Mask<Second>>.if(component).mask
    }
    
    @inlinable
    @_disfavoredOverload
    public static func buildEither<First, Second>(second component: Mask<Second>) -> Mask<IfElse<First, Second>> {
        IfElse<Mask<First>, Mask<Second>>.else(component).mask
    }
    
    @inlinable
    public static func buildEither<Output>(first component: Mask<Output>) -> Mask<Output> {
        component
    }
    
    @inlinable
    public static func buildEither<Output>(second component: Mask<Output>) -> Mask<Output> {
        component
    }
    
    @inlinable
    public static func buildLimitedAvailability<Output>(_ component: Mask<Output>) -> Mask<Output> {
        component
    }
    
    @inlinable
    @_disfavoredOverload
    static func buildOptional<Output>(_ component: Mask<Output>?) -> Mask<Output?> {
        component?.map { $0 } ?? buildBlock().map { nil }
    }
    
    @inlinable
    static func buildOptional(_ component: Mask<Void>?) -> Mask<Void> {
        component ?? buildBlock()
    }
    
    @inlinable
    static func buildArray(_ components: [Mask<Void>]) -> Mask<Void> {
        guard !components.isEmpty else { return buildBlock() }
        guard components.count > 1 else { return components[0] }
        return Mask(
            components.dropFirst().reduce(components[0]) { accumulated, next in
                buildPartialBlock(accumulated: accumulated, next: next)
            }
        )
    }
    
    @inlinable
    @_disfavoredOverload
    static func buildArray<Output>(_ components: [Mask<Output>]) -> Mask<[Output]> {
        guard !components.isEmpty else { return buildBlock().map { [] } }
        return Mask(
            components.dropFirst().reduce(components[0].map { [$0] }) { accumulated, next in
                SequenceMask(first: accumulated, second: next) {
                    $0 + [$1]
                }
                .mask
            }
        )
    }
    
    @inlinable
    public static func buildExpression<T>(_ expression: some MaskComponent<T>) -> Mask<T> {
        expression.mask
    }
}
