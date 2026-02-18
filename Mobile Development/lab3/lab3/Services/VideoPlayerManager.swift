//
//  VideoPlayerManager.swift
//  lab3
//
//  Created by Gheruha Maxim on 18.02.2026.
//

import Foundation
import AVFoundation
import Combine

@MainActor
final class VideoPlayerManager: ObservableObject {
    @Published private(set) var currentIndex: Int = 0
    @Published var isPlaying: Bool = false

    private(set) var player: AVPlayer = AVPlayer()
    private var items: [VideoItem] = []

    func load(items: [VideoItem], startAt index: Int = 0) {
        self.items = items
        setItem(index)
    }

    func setItem(_ index: Int) {
        guard items.indices.contains(index) else { return }
        currentIndex = index

        let name = items[index].fileName
        let parts = name.split(separator: ".", maxSplits: 1).map(String.init)
        guard parts.count == 2 else { return }

        guard let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1]) else {
            assertionFailure("Video not found in bundle: \(name)")
            return
        }

        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        isPlaying = true
    }

    func next() {
        guard !items.isEmpty else { return }
        setItem((currentIndex + 1) % items.count)
    }

    func previous() {
        guard !items.isEmpty else { return }
        setItem((currentIndex - 1 + items.count) % items.count)
    }

    func playPause() {
        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}
