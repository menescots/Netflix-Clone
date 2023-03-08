//
//  YoutubeResponseModel.swift
//  NetflixClone
//
//  Created by Agata Menes on 07/03/2023.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String?
    
    enum CodingKeys: String, CodingKey {
        case kind
        case videoId = "videoId"
    }
}
