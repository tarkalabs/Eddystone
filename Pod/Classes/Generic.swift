public class Generic: Object {
   
    //MARK: Properties
    private(set) public var url: NSURL?
    private(set) public var namespace: String?
    private(set) public var instance: String?
    public var uid: String? {
        get {
            if  let namespace = self.namespace,
                let instance = self.instance {
                    return namespace + instance
            }
            return nil
        }
    }
    
    //MARK: Initializations
    init(url: NSURL?, namespace: String?, instance: String?, signalStrength: Beacon.SignalStrength, identifier: String) {
        self.url = url
        self.namespace = namespace
        self.instance = instance
        
        var urlString = ""
        if let absoluteString = url?.absoluteString {
            urlString = absoluteString
        }
        
        var uid = ""
        if  let namespace = self.namespace,
            let instance = self.instance {
                uid = namespace + instance
        }
        
        super.init(signalStrength: signalStrength, identifier: urlString + uid + identifier)
    }
    
}
