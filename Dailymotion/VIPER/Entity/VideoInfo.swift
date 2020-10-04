//
//  VideoInfo.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

class VideoInfo: Codable {
    var id: String?
    var title: String?
    var thumbnail_240_url: String?
}

class Videos: Codable {
    var page: Int = 0
    var limit: Int = 0
    var has_more: Bool = false
    var list: [VideoInfo]?
}

