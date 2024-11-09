import Foundation
import Combine

struct School: Codable {
    let school_name: String
}
class GetSchools: ObservableObject {
    @Published var schools: [School] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSchools(state: String) {
        guard let url = URL(string: "http://busseater-env.eba-nxi9tenj.us-east-2.elasticbeanstalk.com/\(state)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [School].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.schools, on: self)
            .store(in: &cancellables)
    }
}
