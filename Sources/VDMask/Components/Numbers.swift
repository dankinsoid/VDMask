import Foundation

extension BinaryInteger {
    
    public typealias Mask = NumericMask<Self>
}

public struct NumericMask<N: Numeric & Comparable>: MaskComponent {
    
    let minus: UnicodeScalar?
		let groupingSeparator: String
    let point: String?
    let range: Range<N>?
    
    public var mask: Mask<N> {
        let mask = Mask {
            if let minus {
                Repeat([minus], 0...1)
            }
            OneOf {
                Constant("0")
                Mask {
                    Repeat("1"..."9", 1)
                    Repeat("0"..."9", 0...2)
                    Repeat(0...) {
                        groupingSeparator
                        Repeat("0"..."9", 3)
                    }
                }.joined()
            }
            if let point {
                Repeat(0...1) {
                    point
                    Repeat("0"..."9", 1...)
                }
            }
        }
        return mask.map { _ in
            N.init(exactly: 0)!
        }
    }
}
