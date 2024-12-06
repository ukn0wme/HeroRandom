import UIKit
import Alamofire
import Kingfisher

struct Hero: Decodable {
    let name: String
    let biography: Biography
    let images: HeroImage
    let powerstats: Powerstats
    let appearance: Appearance
    let work: Work

    struct Biography: Decodable {
        let fullName: String
        let publisher: String
        let alignment: String
    }
    
    struct Appearance: Decodable {
        let gender: String
    }
    
    struct Work: Decodable {
        let occupation: String
    }
    
    struct Powerstats: Decodable {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
    }

    struct HeroImage: Decodable {
        let sm: String
    }
}

class ViewController: UIViewController {
    @IBOutlet private weak var heroImage: UIImageView!
    @IBOutlet private weak var heroName: UILabel!
    @IBOutlet private weak var heroFullName: UILabel!
    @IBOutlet private weak var heroIntelligence: UILabel!
    @IBOutlet private weak var heroStrength: UILabel!
    @IBOutlet private weak var heroSpeed: UILabel!
    @IBOutlet private weak var heroGender: UILabel!
    @IBOutlet private weak var heroOccupation: UILabel!
    @IBOutlet private weak var heroPublisher: UILabel!
    @IBOutlet private weak var heroAlignment: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup, if needed
    }
    
    @IBAction func heroRandomize(_ sender: UIButton) {
        let randomId = Int.random(in: 1...563)
        fetchHero(by: randomId)
    }
    
    private func fetchHero(by id: Int) {
        let urlString = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        AF.request(urlString).validate().responseDecodable(of: Hero.self) { response in
            switch response.result {
            case .success(let hero):
                DispatchQueue.main.async {
                    self.updateUI(with: hero)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayError(error: error)
                }
            }
        }
    }
    
    private func updateUI(with hero: Hero) {
        heroName.text = hero.name
        heroFullName.text = hero.biography.fullName
        heroIntelligence.text = hero.powerstats.intelligence.map { String($0) } ?? "N/A"
        heroStrength.text = hero.powerstats.strength.map { String($0) } ?? "N/A"
        heroSpeed.text = hero.powerstats.speed.map { String($0) } ?? "N/A"
        heroGender.text = hero.appearance.gender
        heroOccupation.text = hero.work.occupation
        heroPublisher.text = hero.biography.publisher
        heroAlignment.text = hero.biography.alignment
        
        // Use Kingfisher to set the image
        if let imageUrl = URL(string: hero.images.sm) {
            heroImage.kf.setImage(with: imageUrl)
        } else {
            heroImage.image = nil
        }
    }
    
    private func displayError(error: Error) {
        heroName.text = "Error fetching hero: \(error.localizedDescription)"
        heroFullName.text = ""
        heroIntelligence.text = ""
        heroStrength.text = ""
        heroSpeed.text = ""
        heroGender.text = ""
        heroOccupation.text = ""
        heroPublisher.text = ""
        heroAlignment.text = ""
        heroImage.image = nil
    }
}
