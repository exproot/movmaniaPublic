//
//  MediaService.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

final class MediaService {
    func fetchPopularActors(with endpoint: Endpoint, completion: @escaping ([PopActor]) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(ActorListModel.self, from: data)
                    completion(model.results)
                } catch {
                    fatalError(error.localizedDescription)
                }
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    func fetchActorsMedias(with endpoint: Endpoint, completion: @escaping ([AsCast]) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(ActorCreditsModel.self, from: data)
                    completion(model.cast)
                } catch {
                    fatalError(error.localizedDescription)
                }
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    func fetchActor(with endpoint: Endpoint, completion: @escaping (Cast) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(Cast.self, from: data)
                    completion(model)
                } catch {
                    fatalError(error.localizedDescription)
                }
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    func fetchCast(with endpoint: Endpoint, completion: @escaping ([Cast]) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                completion((self?.handleWithData(data))!)
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    func fetchVideo(with endpoint: Endpoint, completion: @escaping ([VideoResult]) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                completion((self?.handleWithData(data))!)
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    func fetchMedia(with endpoint: Endpoint, completion: @escaping (MediaResult) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                completion((self?.handleWithData(data))!)
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }

    func fetchMedias(with endpoint: Endpoint, completion: @escaping ([MediaResult]) -> Void) {
        NetworkManager.shared.download(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                completion((self?.handleWithData(data))!)
            case .failure(let error):
                self?.handleWithError(error)
            }
        }
    }
    
    private func handleWithData(_ data: Data) -> [Cast] {
        do {
            let model = try JSONDecoder().decode(CastModel.self, from: data)
            return model.cast
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func handleWithData(_ data: Data) -> [VideoResult] {
        do {
            let model = try JSONDecoder().decode(VideoModel.self, from: data)
            return model.results
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func handleWithData(_ data: Data) -> MediaResult {
        do {
            let model = try JSONDecoder().decode(MediaResult.self, from: data)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func handleWithData(_ data: Data) -> [MediaResult] {
        do {
            let model = try JSONDecoder().decode(MediaModel.self, from: data)
            return model.results
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}


