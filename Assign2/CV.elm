module Main exposing (..)


import Html.Attributes exposing (..)

import Html exposing (..)


myStyle = style [ ("background-color", "AliceBlue")
                , ("margin-left", "50px")
                , ("margin-right", "50px")
                , ("font-style","Platino")
                ]
mS = style [ ("margin-left", "90px")
           , ("margin-right", "300px")]

leftHS = style [ ("margin-left", "90px")
               ]

imgStyle = style [("max-width","200px")
                   ,("height", "200px")
                   , ("float", "right")
                   , ("margin-right", "20px")
                   ]

borderS = style [ ("float","right")
                , ("border-left", "5px dashed grey")
                , ("height", "1050px")
                , ("position", "relative")
                , ("right","20px")
                ]

pS = style [ ("float","right")
           , ("position", "relative")
           , ("top", "150px")
           , ("right","-190px")
           ]

subS = style [
             ("font-weight","bold")
             ]

fS = style [("text-align", "center")]


main = div[myStyle]

        [
        header [leftHS]
            [
            img [src "1.jpg",imgStyle] []
            ,h1 [] [text "Kexin Liu"]
            ,p [borderS] []
            ],

        address [pS]
            [ 
            p [] [text "Tel: 905-962-8293"]
            ,p [] [text "Email: liuk44mcmaster.ca"]
            ,p [] [text "Address: 69 Emerson St,"]
            ,p [] [text "Ontario, Canada   L8S 2X5"]
            ],
        section [mS]
            [
            h2 [] [text "PROFILE"]
            ,p [] [text "First Year Student in Computer Science Co-op who is one of the recipients of Dean’s Excellence Entrance Scholarship and Undergraduate Summer Research Award. Developed communication and technical skills and leadership ability through involvements in a diverse range of experiences on campus and in the community."]
            ],
        section [mS]
            [
            h2 [] [text "EDUCATION"]
            ,p [subS] [text "Bachelor of Engineering, Computer Science McMaster University"]
            ],
        section [mS]
            [
            h2 [] [text "EXPERIENCE"]
            ,p [subS] [text "Member"]
            ,p [subS] [text "of Chinese Students and Scholars Association, McMaster University"]
            ,ul [] [
                    li [] [text "Worked alongside 57 members to help away-from-home Chinese students in the areas of their life, study, work, and other issues. Developed computer skills through developing softwares for the association to make working more efficient."]       
                   ]
            ,p [subS] [text "Member"]
            ,p [subS] [text "of Student Council, Xinhua High School, Tianjin, China"]
            ,ul [] [
                    li [] [text "Helped set up study plans for students who wished to achieve good grades andencouraged them to participate in cooperation and sharing good study tips."]
                    ]
            ,p [subS] [text "President"]
            ,p [subS] [text "of Community Recycling Club, Ruijiang Community, Tianjin, China"]
            ,ul [] [
                    li [] [text "Managed a team of over 20 teenage volunteers to take part in social activities and engage in raising recycling awareness in our community."]
                    ,li [] [text "Excellent Teenager Award, 2010"]
                    ]

            ],  
        section [mS]
            [
            h2 [] [text "VOLUNTEER"]
            ,p [subS] [text "Teacher Assistant"]
            ,p [subS] [text "of Youth International Learning Program, Guelph"]
            ,ul [] [
                    li [] [text "Supervised children in class and during recess as well as helped teacher prepare for lessons. Performed a dance show with children at Spring Festival."]
                    ,li [] [text "Improved problem-solving skills and communication skills by dealing with children’s problems and talking to their parents"]
                   ]
            ],
        section [mS]
            [
            h2 [] [text "SKILLS"]
            ,ul [] [
                    li [] [text "Technical Skill"]
                    ,ol [] [
                            li [] [text "High School Coursework: ", a [ href "https://www.khanacademy.org/computer-programming/game-challenge/5464032449200128"] [text "JavaScript Game Challenge"] ]
                            ,li [] [text "CS 1XA3 Coursework: ", a [ href "http://ugweb.cas.mcmaster.ca/~liuk44/elmApp.html"] [text "Elm Game App"] ]
                            ]
                    ]
            ],
        section [mS]
            [
            h2 [] [text "AWARDS AND ACHIEVEMENTS"]
            ,ul [] [
                    li [] [text "Dean’s Excellence Entrance Scholarship"]
                    ,li [] [text "Euclid Mathematics Contest, ranked top 5%"]
                    ,li [] [text "Canadian Senior Mathematics Contest , Certificate of Distinction (top 25%)"]
                    ]
            ],
        footer []
            [
            h4 [fS] [text "Copyright liuk44 @ 2018"]
            ]
        ]
