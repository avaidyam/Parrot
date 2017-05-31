import Foundation

public protocol Directory: class, ServiceOriginating /*: Collection*/ {
    
    /// Return the user currently logged into the Service.
    var me: Person { get }
    
    /// Return all users the current user can locate mapped by their unique ID.
    var people: [Person.IdentifierType: Person] { get }
    
    /// Returns all pending invitations requested to the current user.
    var invitations: [Person.IdentifierType: Person] { get }
    
    /// Returns all the people blocked by the current user.
    var blocked: [Person.IdentifierType: Person] { get }
    
    /// Return the Person identified the string provided.
    subscript(_ identifier: Person.IdentifierType) -> Person { get }
    
    /// Search for users given a set of identifiers.
    /// Identifiers can include anything including name components.
    /// Returns a set of users that could be possible matches.
    func lookup(by: [Person.IdentifierType]) -> [Person]
    func lookup(by: [Person.IdentifierType], limit: Int) -> [Person]
}
