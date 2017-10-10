//import XPCServices
import Cocoa
import os
import Mocha
import Hangouts

public class ParrotAgentController: XPCService {
    
    public override func serviceDidFinishLaunching() {
        os_log("launched app")
        let u = NSUserNotification()
        u.title = "Parrot is running in the background."
        NSUserNotificationCenter.default.deliver(u)
    }
    
    public override func serviceWillTerminate() {
        os_log("app terminated!")
        let u = NSUserNotification()
        u.title = "Parrot is no longer running in the background."
        NSUserNotificationCenter.default.deliver(u)
    }
    
    public override func serviceShouldAccept(connection: XPCConnection) -> Bool {
        return true
    }
    
    public override func serviceConnection(_ connection: XPCConnection, received event: xpc_object_t) {
        os_log("responding to event...")
        if  let con = xpc_dictionary_get_remote_connection(event),
            let msg = xpc_dictionary_create_reply(event) {
            
            os_log("advance to signin phase")
            Authenticator.authenticateClient {
                
                let response = $0.httpCookieStorage!.cookies ?? []
                os_log("sending response %@", response)
                let person = _CookieResponse(response)
                
                do {
                    let encoded = try XPCEncoder(options: [.primitiveRootValues, .overwriteDuplicates]).encode(person)
                    xpc_dictionary_set_value(msg, "response", encoded)
                } catch(let err) {
                    os_log("ENCODE ERROR %@", String(describing: err))
                    xpc_dictionary_set_string(msg, "error", "could not synth")
                }
                
                xpc_connection_send_message(con, msg)
            }
        }
    }
}

Authenticator.delegate = WebDelegate.delegate
ParrotAgentController.run()
