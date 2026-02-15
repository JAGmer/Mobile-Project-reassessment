
import Foundation
import UIKit

var personalityQuizzes: [PersonalityQuizType] = [
    PersonalityQuizType(
        type: .Animal,
        images: [.lion: UIImage(named: "backgrounds/lion-background"), .cat: UIImage(named: "backgrounds/cat-background"), .dog: UIImage(named: "backgrounds/dog-background"), .rabbit: UIImage(named: "backgrounds/rabbit-background")],
        id: 1,
        title: "What Animal Are You?",
        icon1 : "🦁", icon2 : "🐱", icon3 : "🐶", icon4 : "🐰",
        questions: [
            Question(
                text: "Which food do you like the most?",
                type: .single,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Steak", type: .lion),
                    Answer(text: "Fish", type: .cat),
                    Answer(text: "Carrots", type: .rabbit),
                    Answer(text: "Chocolate", type: .dog)
                ]
            ),
            
            Question(
                text: "Which Activites do you enjoy?",
                type: .multiple,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Running", type: .dog),
                    Answer(text: "Sleeping", type: .cat),
                    Answer(text: "Cuddling", type: .rabbit),
                    Answer(text: "Eating", type: .lion)
                ]
            ),
            
            Question(
                text: "How much do you enjoy car rides?",
                type: .ranged,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "I dislike them", type: .cat),
                    Answer(text: "I get a little nervous", type: .rabbit),
                    Answer(text: "I barely notice them", type: .dog),
                    Answer(text: "I love them", type: .lion)
                ]
            )
    ]),
    
    PersonalityQuizType(
        type: .Superhero,
        images: [.superman: UIImage(named: "backgrounds/superman-background"), .batman: UIImage(named: "backgrounds/batman-background"), .spider: UIImage(named: "backgrounds/spiderman-background"), .daredevil: UIImage(named: "backgrounds/daredevil-background")],
        id: 2,
        title: "Which Superhero Are You?",
        icon1 : "🦸‍♂️", icon2 : "🦇", icon3 : "🕸️", icon4 : "👹",
        questions: [
            Question(
                text: "Which time of day you like the most?",
                type: .multiple,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Dawn", type: .batman),
                    Answer(text: "Morning", type: .superman),
                    Answer(text: "Noon", type: .spider),
                    Answer(text: "Night", type: .daredevil)
                ],
                
            ),
            Question(
                    text: "How important is justice to you?",
                    type: .ranged,
                    timeInSeconds: 15,
                    answers: [
                        Answer(text: "Not much", type: .spider),
                        Answer(text: "A little", type: .daredevil),
                        Answer(text: "Very", type: .superman),
                        Answer(text: "Absolutely everything", type: .batman)
                    ]
                ),

                Question(
                    text: "How would you use your power",
                    type: .ranged,
                    timeInSeconds: 15,
                    answers: [
                        Answer(text: "Just enough to help", type: .daredevil),
                        Answer(text: "To help people in my neighborhood", type: .spider),
                        Answer(text: "Take out the bad guys in my city", type: .batman),
                        Answer(text: "World Peace", type: .superman)
                    ]
                ),
            Question(
                   text: "Which environment fits you best?",
                   type: .single,
                   timeInSeconds: 15,
                   answers: [
                       Answer(text: "Dark rooftops", type: .batman),
                       Answer(text: "Open skies", type: .superman),
                       Answer(text: "City streets", type: .spider),
                       Answer(text: "Quiet neighborhoods", type: .daredevil)
                   ]
               ),

               Question(
                   text: "What drives you the most?",
                   type: .multiple,
                   timeInSeconds: 15,
                   answers: [
                       Answer(text: "Justice", type: .batman),
                       Answer(text: "Hope", type: .superman),
                       Answer(text: "Responsibility", type: .spider),
                       Answer(text: "Protection of the innocent", type: .daredevil)
                   ]
               ),

               Question(
                   text: "Pick a fighting style:",
                   type: .single,
                   timeInSeconds: 15,
                   answers: [
                       Answer(text: "Strategic and prepared", type: .batman),
                       Answer(text: "Strong and direct", type: .superman),
                       Answer(text: "Fast and agile", type: .spider),
                       Answer(text: "Close and precise", type: .daredevil)
                   ]
               )
            
    ]),
    
    PersonalityQuizType(
        type: .gameCharacter,
        images: [.cloud: UIImage(named: "backgrounds/cloud-background"), .terry: UIImage(named: "backgrounds/terry-background"), .snake: UIImage(named: "backgrounds/mgs-background"), .agent47: UIImage(named: "backgrounds/hitman-background")],
        id: 3,
        title: "What video game character are you?",
        icon1: "👨🏻‍🎤", icon2: "🧢", icon3: "📦", icon4: "🤵🏻‍♂️",
        questions: [
            Question(
                text: "How would you get through encounters?",
                type: .single,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Using unique tactics and moves", type: .cloud),
                    Answer(text: "Special punches", type: .terry),
                    Answer(text: "Backing down and hinding", type: .snake),
                    Answer(text: "Creating distractions", type: .agent47)
                ]),
            Question(
                text: "What methods would you use to pass barriers?",
                type: .single,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Special items and magic", type: .cloud),
                    Answer(text: "Fighting my way through", type: .terry),
                    Answer(text: "swift jumps and parkour", type: .snake),
                    Answer(text: "using what's in the vicinity", type: .agent47)
                ]),
            Question(
                text: "What elements in dungeons do you like?",
                type: .multiple,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "Puzzles", type: .cloud),
                    Answer(text: "Encounters", type: .terry),
                    Answer(text: "Dark areas", type: .snake),
                    Answer(text: "Open spaces", type: .agent47)
                ]),
            Question(
                text: "How much power you would like to have?",
                type: .ranged,
                timeInSeconds: 15,
                answers: [
                    Answer(text: "enough to pass through", type: .snake),
                    Answer(text: "Some power to work with my tools", type: .agent47),
                    Answer(text: "A lot of power to defeat my foes", type: .terry),
                    Answer(text: "Immense Power", type: .cloud)
                ])
        ]
    )
]

