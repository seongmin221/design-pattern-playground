import UIKit

let baseURLString = "http://www.randomnumberapi.com/api/v1.0/randomstring"

typealias RandomStringResponse = [String]

// Builder Pattern practice

class QueryBuilder {
    enum Query {
        case min(Int)
        case max(Int)
        case count(Int)
        case all(Bool)
        
        var queryString: URLQueryItem {
            switch self {
            case let .min(count): return .init(name: "min", value: count.description)
            case let .max(count): return .init(name: "max", value: count.description)
            case let .count(count): return .init(name: "count", value: count.description)
            case let .all(isAll): return .init(name: "all", value: isAll.description)
            }
        }
    }
    
    private var operations: [Query] = []
    
    func min(_ count: Int) -> QueryBuilder {
        operations.append(.min(count))
        return self
    }
    
    func max(_ count: Int) -> QueryBuilder {
        operations.append(.max(count))
        return self
    }
    
    func count(_ count: Int) -> QueryBuilder {
        operations.append(.count(count))
        return self
    }
    
    func all(_ isAll: Bool) -> QueryBuilder {
        operations.append(.all(isAll))
        return self
    }
    
    func createURL() -> URL {
        let baseURL = URL(string: baseURLString)!
        var queryItems: [URLQueryItem] = []
        for operation in operations {
            queryItems.append(operation.queryString)
        }
        return baseURL.appending(queryItems: queryItems)
    }
}

// MARK: - Ordinary API Service

final class StringAPIService {
    
    static let shared = StringAPIService()
    let baseURL: URL = .init(string: baseURLString)!
    
    private init() {}
    
    func fetchRandomString(
        from requestURL: URL
    ) async throws -> [String] {
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard let response = response as? HTTPURLResponse else { return [] }
        switch response.statusCode {
        case 200..<300:
            let result = try JSONDecoder().decode([String].self, from: data)
            return result
        default: throw URLError(.badServerResponse)
        }
    }
}

final class SampleViewController1: UIViewController {
    
    let queryBuilder = QueryBuilder()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let requestURL = queryBuilder
            .min(5)
            .max(20)
            .count(5)
            .createURL()
        Task {
            do {
                let strings = try await StringAPIService.shared.fetchRandomString(from: requestURL)
                dump(strings)
            }
            catch {
                NSError()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let viewController = SampleViewController1()
