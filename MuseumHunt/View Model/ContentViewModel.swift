//
//  ContentViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

final class ContentViewModel {
    
    var audioPlayer = AVPlayer()
    var videoPlayer = AVPlayer()

    func prepareAudio(with audioUrl: String){
        guard let url = URL(string: audioUrl) else { return }
        
        audioPlayer = AVPlayer(url: url)
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback)
    }
    func playAudio(){
        audioPlayer.play()
    }
    func pauseAudio(){
        audioPlayer.pause()
    }
    func restartAudio(){
        audioPlayer.seek(to: .zero)
        audioPlayer.play()
    }
    func prepareVideo(with videoUrl: String) -> AVPlayer{
        guard let url = URL(string: videoUrl) else { return AVPlayer() }
        
        videoPlayer = AVPlayer(url: url)
        
        return videoPlayer
    }
    func playVideo(){
        videoPlayer.play()
    }
    
}
