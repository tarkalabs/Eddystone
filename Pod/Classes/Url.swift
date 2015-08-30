public class Url: Object {
    
    //MARK: Properties
    private(set) public var url: NSURL
    
    //MARK: Initializations
    init(url: NSURL, signalStrength: Beacon.SignalStrength, identifier: String) {
        self.url = url
        
        var urlString = ""
        if let absoluteString:String? = url.absoluteString {
            urlString = absoluteString!
        }
        
        super.init(signalStrength: signalStrength, identifier: urlString + identifier)
    }
    
}