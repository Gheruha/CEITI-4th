import SwiftUI

struct ContentView: View {
    @StateObject private var audio = AudioPlayerManager()

    private let songs: [Song] = [
        Song(title: "FEVER", artist: "BUCKSHOT & FAKEMINK", fileName: "song1.mp3", coverName: "cover1"),
        Song(title: "Broken Trust", artist: "SAY3AM, Staarz", fileName: "song2.mp3", coverName: "cover2"),
        Song(title: "When you're overqualified", artist: "Asia", fileName: "song3.mp3", coverName: "cover3"),
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                if let song = audio.currentSong() {
                    Image(song.coverName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    VStack(spacing: 6) {
                        Text(song.title)
                            .font(.title2.weight(.semibold))
                        Text(song.artist)
                            .font(.subheadline)
                            .opacity(0.75)
                    }
                    .foregroundStyle(.white)
                }

                HStack(spacing: 28) {
                    circleButton(system: "backward.fill") {
                        audio.previous()
                    }

                    circleButton(system: audio.isPlaying ? "pause.fill" : "play.fill") {
                        audio.playPause()
                    }

                    circleButton(system: "forward.fill") {
                        audio.next()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            audio.load(songs: songs, startAt: 0)
        }
    }

    @ViewBuilder
    private func circleButton(system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 84, height: 84)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ContentView()
}
