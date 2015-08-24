public class Uid: Object {
    
    //MARK: Properties
    private(set) public var namespace: String
    private(set) public var instance: String
    public var uid: String {
        get {
            return self.namespace + self.instance
        }
    }
    
    //MARK: Initializations
    init(namespace: String, instance: String, signalStrength: Beacon.SignalStrength, var identifier: String) {
        self.namespace = namespace
        self.instance = instance
        
        super.init(signalStrength: signalStrength, identifier: namespace + instance + identifier)
    }
    
}