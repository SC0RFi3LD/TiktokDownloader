//
//  TicktokDetailModel.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation

// MARK: TicktokModel
struct TicktokDetailModel: Codable {
    var code: Int?
    var msg: String?
    var processedTime: Double?
    var data: DataModel?

    enum CodingKeys: String, CodingKey {
        case code, msg
        case processedTime = "processed_time"
        case data
    }
}

// MARK: Data
struct DataModel: Codable {
    var id, region, title: String?
    var cover: String?
    var originCover: String?
    var duration: Int?
    var play, wmplay: String?
    var size, wmSize: Int?
    var music: String?
    var musicInfo: MusicInfoModel?
    var playCount, diggCount, commentCount, shareCount: Int?
    var downloadCount, createTime: Int?
    var author: AuthorModel?

    enum CodingKeys: String, CodingKey {
        case id, region, title, cover
        case originCover = "origin_cover"
        case duration, play, wmplay, size
        case wmSize = "wm_size"
        case music
        case musicInfo = "music_info"
        case playCount = "play_count"
        case diggCount = "digg_count"
        case commentCount = "comment_count"
        case shareCount = "share_count"
        case downloadCount = "download_count"
        case createTime = "create_time"
        case author
    }
}

// MARK: Music
struct MusicInfoModel: Codable {
    var id, title: String?
    var play: String?
    var cover: String?
    var author: String?
    var original: Bool?
    var duration: Int?
    var album: String?
}

// MARK: Author
struct AuthorModel: Codable {
    var id, uniqueID, nickname: String?
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueID = "unique_id"
        case nickname, avatar
    }
}
