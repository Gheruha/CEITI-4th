//
//  AudioPlayerManager.swift
//  AudioPlayer
//
//  Created by Gheruha Maxim on 16.02.2026.
//

import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioPlayerManager: ObservableObject {
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var currentIndex: Int = 0

    private var player: AVAudioPlayer?
    private var songs: [Song] = []

    func load(songs: [Song], startAt index: Int = 0) {
        self.songs = songs
        setSong(index)
    }

    func setSong(_ index: Int) {
        guard songs.indices.contains(index) else { return }
        currentIndex = index

        // Stop old player
        player?.stop()
        player = nil
        isPlaying = false

        // Load file from bundle
        let name = songs[index].fileName
        let parts = name.split(separator: ".", maxSplits: 1).map(String.init)
        guard parts.count == 2 else {
            assertionFailure("fileName must include extension, e.g. song1.mp3")
            return
        }

        guard let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1]) else {
            assertionFailure("Audio file not found in bundle: \(name)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            assertionFailure("Failed to init AVAudioPlayer: \(error)")
        }
    }

    func playPause() {
        guard let player else { return }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func next() {
        guard !songs.isEmpty else { return }
        let nextIndex = (currentIndex + 1) % songs.count
        setSong(nextIndex)
        player?.play()
        isPlaying = true
    }

    func previous() {
        guard !songs.isEmpty else { return }
        let prevIndex = (currentIndex - 1 + songs.count) % songs.count
        setSong(prevIndex)
        player?.play()
        isPlaying = true
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
    }

    func currentSong() -> Song? {
        guard songs.indices.contains(currentIndex) else { return nil }
        return songs[currentIndex]
    }
}
