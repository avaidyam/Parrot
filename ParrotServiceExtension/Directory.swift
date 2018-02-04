
public protocol Directory: class, ServiceOriginating /*: Collection*/ {
    
    /// Return the user currently logged into the Service.
    var me: Person { get }
    
    /// Return all users the current user can locate mapped by their unique ID.
    var people: [Person.IdentifierType: Person] { get }
    
    /// Returns all pending invitations requested to the current user.
    var invitations: [Person.IdentifierType: Person] { get }
    
    /// Returns all the people blocked by the current user.
    var blocked: [Person.IdentifierType: Person] { get }
    
    ///
    func search(by: String, limit: Int) -> [Person]
    
    ///
    func list(_ limit: Int) -> [Person]
    
    /// Search for users given a set of identifiers.
    /// Identifiers can include anything including name components.
    /// Returns a set of users that could be possible matches.
    //func find(by: [Person.IdentifierType], limit: Int) -> [Person]
}
