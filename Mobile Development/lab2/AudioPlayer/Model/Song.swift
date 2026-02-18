//
//  Song.swift
//  AudioPlayer
//
//  Created by Gheruha Maxim on 16.02.2026.
//

import Foundation

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let fileName: String     // without extension if you want; we'll store full name here
    let coverName: String    // asset name
}
