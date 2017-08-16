import FluentProvider
import RedisProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(RedisProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(Post.self)
        preparations.append(User.self)
        preparations.append(GoodsCategory.self)
        preparations.append(GoodsUnit.self)
        preparations.append(Goods.self)
        preparations.append(GoodsStock.self)
        preparations.append(Timeline.self)
    }
}
