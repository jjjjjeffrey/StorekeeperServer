import Vapor

extension Droplet {
    func setupRoutes() throws {

        
        
        post("smsCode", handler: SMSController().sendSMSCode)
        post("authSMSCode", handler: SMSController().authSMSCode)
        post("register", handler: PassportController().mobileRegister)
        post("login", handler: PassportController().mobileLogin)
        
        let auth = grouped(AuthenticationMiddleware())
        auth.get("user", handler: PassportController().getUserInfo)
        
        try resource("posts", PostController.self)
    }
}
