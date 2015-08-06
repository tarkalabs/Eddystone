public class Url: Object, Equatable {
    
    //MARK: Properties
    public var url: NSURL
    
    //MARK: Initializations
    init(url: NSURL, signalStrength: Beacon.SignalStrength) {
        self.url = url
        
        super.init(signalStrength: signalStrength)
    }
    
}

public func ==(lhs: Url, rhs: Url) -> Bool {
    return lhs.url.absoluteString == rhs.url.absoluteString
}