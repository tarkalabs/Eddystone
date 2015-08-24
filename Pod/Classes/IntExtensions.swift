/**
    IntExtensions.swift

    Convert an arbitrary length byte array into a Swift Int

    <https://gist.github.com/e720877bf7700138eb99.git>
*/

extension Int {
    static func fromByteArray(bytes: [UInt8]) -> Int {
        var int = 0
        
        for (offset, byte) in enumerate(bytes) {
            let factor =  bytes.count - (offset + 1);
            if factor > 0 {
                int += Int(byte) * (256 * factor)
            } else {
                int += Int(byte)
            }
        }
        
        return int
    }
}