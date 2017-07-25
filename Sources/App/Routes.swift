import Vapor

extension Droplet {
    func setupRoutes() throws {

        
        
        post("smsCode", handler: SMSController().sendSMSCode)
        post("authSMSCode", handler: SMSController().authSMSCode)
        post("userRegister", handler: PassportController().mobileRegister)
        
        
        try resource("posts", PostController.self)
    }
}
