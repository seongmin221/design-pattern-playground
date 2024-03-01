import PlaygroundSupport
import XCTest

protocol DomainModel {}

struct User: DomainModel {
    let id: Int
    let age: Int
    let email: String
}

class BaseQueryBuilder<Model: DomainModel> {
    typealias Predicate = (Model) -> (Bool)
    
    func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        return self
    }
    
    func filter(_ predicate: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }
    
    func fetch() -> [Model] {
        preconditionFailure("Should be overriden in subclasses")
    }
}

class RealmQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    enum Query {
        case limit(Int)
        case filter(Predicate)
    }
    
    fileprivate var operations: [Query] = []
    
    @discardableResult
    override func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }
    
    @discardableResult
    override func filter(_ predicate: @escaping BaseQueryBuilder<Model>.Predicate) -> BaseQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }
    
    override func fetch() -> [Model] {
        print("RealmQueryBuilder: init with \(operations.count) operations")
        return RealmProvider().fetch(operations)
    }
}


class RealmProvider {
    
    func fetch<Model: DomainModel>(_ operations: [RealmQueryBuilder<Model>.Query]) -> [Model] {
        
        print("RealmProvider: Retrieving data from Realm...")
        
        for query in operations {
            switch query {
            case .filter(_):
                print("RealmProvider: some filter operations")
                break
                
            case .limit(_):
                print("RealmProvider: some limit operations")
                break
            }
        }
        
        return []
    }
}


// Client

class BuilderRealWorld: XCTestCase {
    
    func test_builderRealWorld() {
        print("Client: Start fetching data from realm")
        
        let builder = RealmQueryBuilder<User>()
        let results = builder
            .filter { user in
                user.age > 20
            }
            .limit(5)
            .fetch()
        
        print("Client: fetched \(results.count) data")
    }
}

BuilderRealWorld().test_builderRealWorld()
