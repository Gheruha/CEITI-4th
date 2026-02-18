//
//  ContentView.swift
//  lab3
//
//  Created by Gheruha Maxim on 18.02.2026.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var video = VideoPlayerManager()

    // For students: Add your videos inside the Resources/ folder.
    private let items: [VideoItem] = [
        VideoItem(title: "Video 1", fileName: "video1.MOV"),
        VideoItem(title: "Video 2", fileName: "video2.MOV"),
        VideoItem(title: "Video 3", fileName: "video3.MOV"),
    ]

    var body: some View {
        ZStack {
            VideoPlayer(player: video.player)
                .ignoresSafeArea() // full screen

            // Controls overlay
            VStack {
                Spacer()

                HStack(spacing: 28) {
                    CircleButton(systemName: "backward.fill") { video.previous() }
                    CircleButton(systemName: video.isPlaying ? "pause.fill" : "play.fill") { video.playPause()  }
                    CircleButton(systemName: "forward.fill") { video.next() }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            video.load(items: items, startAt: 0)
        }
    }
}

#Preview {
    ContentView()
}
