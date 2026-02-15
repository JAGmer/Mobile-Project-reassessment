
//
//  Question.swift
//  Personality Quiz
//
//  Created by BP-36-201-17 on 02/02/2026.
//

import Foundation
import UIKit

enum QuizType: String
{
    case Animal, Superhero, gameCharacter
    
    var title: String
    {
        rawValue.capitalized
    }
}


struct PersonalityQuizType
{
    var type: QuizType
    var images: [PersonalityType: UIImage?]
    var id: Int
    var title: String
    var icon1: String
    var icon2: String
    var icon3: String
    var icon4: String
    var questions: [Question]
}

struct Question
{
    var text: String
    var type: ResponseType
    var timeInSeconds: Int
    var answers: [Answer]
}

struct Answer
{
    var text: String
    var type: PersonalityType
}

enum ResponseType
{
    case single, multiple, ranged
}

enum PersonalityType: Character
{
    case lion = "🦁", cat = "🐱", dog = "🐶", rabbit = "🐰", superman = "🦸‍♂️", batman = "🦇", spider = "🕸️", daredevil = "👹", cloud = "👨🏻‍🎤", terry = "🧢", snake = "📦", agent47 = "🤵🏻‍♂️"
    
    var definition: String
    {
        switch self
        {
        case .lion:
            return "Your are incredibly outgoing. You surround yourself with the people you love and enjoy activites with your friends."
        case .cat:
            return "Mischievous, yet mild-tempered, you enjoy doing things on your own terms."
        case .dog:
            return "Loyal, kind-hearted, and deeply caring. You form strong bonds and make people feel safe just by being around you. You are always there when it counts."
        case .rabbit:
            return "Your love everything that's soft. Your are helthy and full of energy."
        case .superman:
            return "You are not here to rule anyone, you are here to help people achieve their dreams, and you think anyone can achieve it if they are given the chance."
        case .batman:
            return "\"Sometimes the truth isn't good enough, sometimes people deserve more. Sometimes people deserve to have their faith rewarded.\""
        case .spider:
            return "\"Spider-Man always gets up.\""
        case .daredevil:
            return "\"We're all just tryin' to do more good than harm\""
        case .cloud:
            return "\"I wasn't pursuing Sephiroth; I was being summoned by him.\""
        case .terry:
            return "Doing it for the love of the game. Not getting mad about it, just having fun with friends."
        case .snake:
            return "hiding in the shadows, doing your job without being detected using your ultimate friend the box."
        case .agent47:
            return "Completing your mission intelligently and indirectly. crafting methods to make people believe someone else did the task."
        }
    }
}
