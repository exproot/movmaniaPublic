//
//  ActorDetailsViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import Foundation

protocol ActorDetailsViewModelProtocol {
    var view: ActorDetailsViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func setContent()
    func getContentForMediaDetails(indexPath: IndexPath, completion: @escaping ((title: String, desc: String, videoID: String, mediaType: String, mediaID: String)) -> ())
}

final class ActorDetailsViewModel {
    weak var view: ActorDetailsViewControllerProtocol?
    private let mediaService = MediaService()
    public var actorID: String?
    public var knownForMedias: [AsCast] = []
    
    private func calculateAge(from birthday: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let birthDate = dateFormatter.date(from: birthday) else { return nil}
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        if let age = ageComponents.year {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let birthDateString = dateFormatter.string(from: birthDate)
            return "\(birthDateString) (\(age) years old)"
        }else {
            return nil
        }
    }
    
    private func fetchKnownForMedidas(actorId: String) {
        mediaService.fetchActorsMedias(with: Endpoint.fetchActorCredits(actorID: actorId)) { [weak self] medias in
            var uniquePosterPaths = Set<String>()
            var filteredMedias = [AsCast]()
            
            for media in medias {
                if let posterPath = media.posterPath {
                    if !uniquePosterPaths.contains(posterPath) {
                        uniquePosterPaths.insert(posterPath)
                        filteredMedias.append(media)
                    }
                }
            }
            
            self?.knownForMedias = filteredMedias.sorted { $0.voteCount ?? 0 > $1.voteCount ?? 0}
            self?.view?.reloadCollection()
        }
    }
}

extension ActorDetailsViewModel: ActorDetailsViewModelProtocol {
    func getContentForMediaDetails(indexPath: IndexPath, completion: @escaping ((title: String, desc: String, videoID: String, mediaType: String, mediaID: String)) -> ()) {
        let mediaId = String(knownForMedias[indexPath.item]._id)
        let mediaType = knownForMedias[indexPath.item]._mediaType
        let description = knownForMedias[indexPath.item]._overview
        var title = ""
        switch mediaType {
        case "movie":
            title = knownForMedias[indexPath.item]._title
        case "tv":
            title = knownForMedias[indexPath.item]._name
        default:
            title = ""
        }
        var videoId: String = ""
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaId)) { videos in
            for i in videos {
                if i._type == "Trailer" {
                    videoId = i._key
                    break
                } else if videoId == "" && i._type == "Teaser" {
                    videoId = i._key
                } else if videoId == "" && i._type == "Clip" {
                    videoId = i._key
                } else {
                    videoId = i._key
                }
            }
            completion((title, description, videoId, mediaType, mediaId))
        }
    }
    
    func setContent() {
        guard let actorID = actorID else { return }
        view?.presentLoadingView()
        self.fetchKnownForMedidas(actorId: actorID)
        mediaService.fetchActor(with: Endpoint.fetchActorDetails(actorID: actorID)) { [weak self] actor in
            guard let self = self else { return }
            self.view?.cancelLoadingView()
            guard let url = URL(string: "\(Constants.imageBaseURL)\(actor._profilePath)") else { return }
            DispatchQueue.main.async {
                if actor.profilePath != nil {
                    self.view?.setImage(with: url)
                }else {
                    self.view?.setImage(with: nil)
                }
                if let name = actor.name {
                    self.view?.setNameLabel(with: name)
                }else {
                    self.view?.setNameLabel(with: nil)
                }
                if actor.birthday != nil {
                    self.view?.setBirthdayAndAgeLabel(with: self.calculateAge(from: actor._birthday))
                }else {
                    self.view?.setBirthdayAndAgeLabel(with: nil)
                }
                if let placeOfBirth = actor.placeOfBirth {
                    self.view?.setPlaceOfBirthLabel(with: placeOfBirth.trimmingCharacters(in: .whitespaces))
                }else {
                    self.view?.setPlaceOfBirthLabel(with: nil)
                }
                if actor.biography != "" {
                    self.view?.setBiographyLabel(with: String(actor._biography.filter { !"\n".contains($0)}))
                }else {
                    self.view?.setBiographyLabel(with: nil)
                }
            }
        }
    }
    
    func viewDidLoad() {
        self.setContent()
        view?.prepareLabels()
        view?.prepareCollectionView()
        view?.prepareImage()
    }
}
