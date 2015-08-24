import Foundation

public var logging = false

func log(message: AnyObject) {
    if logging {
        println("[Eddystone] \(message)")
    }
}

enum FrameType {
    case URL, UID, TLM
}

typealias Byte = Int