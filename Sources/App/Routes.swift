import Vapor

extension Droplet {
    func setupRoutes() throws {

        
        
        post("smsCode", handler: SMSController().sendSMSCode)
        post("authSMSCode", handler: SMSController().authSMSCode)
        post("register", handler: PassportController().mobileRegister)
        post("login", handler: PassportController().mobileLogin)
        
        let auth = grouped(AuthenticationMiddleware())
        auth.get("user", handler: PassportController().getUserInfo)
        
        try auth.resource("goodsCategory", GoodsCategoryController.self)
        try auth.resource("goodsUnit", GoodsUnitController.self)
        try auth.resource("goods", GoodsController.self)
        try auth.resource("goodsStock", GoodsStockController.self)
        try auth.resource("timeline", TimelineController.self)
        
        try resource("posts", PostController.self)
        
    }
}
