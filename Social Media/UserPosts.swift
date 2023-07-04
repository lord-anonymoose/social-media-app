//
//  userPosts.swift
//  Social Media
//
//  Created by Philipp Lazarev on 05.07.2023.
//

public var myPosts = [
    Post(author: me.login, description: "Breathtaking Dublin ☘️🇮🇪", image: "my_post1", likes: 96, views: 100),
    Post(author: me.login, description: "Wonderful Madrid 🐻🇪🇸", image: "my_post2", likes: 90, views: 99),
    Post(author: me.login, description: "Warm Tbilisi ☀️🇬🇪", image: "my_post3", likes: 89, views: 96 ),
    Post(author: me.login, description: "Calm Paderborn 🏰🇩🇪", image: "my_post4", likes: 88, views: 95)
]

public var posts = [
    Post(author: "katyPerry", description: "hi it's hunger games but also #AmericanIdol (but actually it's duets) 🤺", image: "katyperry_post1", likes: 268_559, views: 300_232),
    Post(author: "katyPerry", description: "You guys! A STAND out collection from moi and @aboutyou is coming Nov 2 🎉", image: "katyperry_post2", likes: 648_560, views: 722_212),
    Post(author: "katyPerry", description: "Happy 15th anniversary to my first musical child, One of the Boys! (I know omg the passing of time is WILD). She may be a young teen but has always had a bit of an attitude. Thank you to all the KCs who have stuck around since the Warped and Hello Katy days... tbh I still think of myself as One of the Boys & #OOTBCoveralts", image: "katyperry_post3", likes: 1_066_070, views: 1_223_543),
    
    Post(author: "teddyphotos", description: "E I E I O, up the football league we go! @ipswichtown", image: "teddyphotos_post1", likes: 133_425, views: 331_123),
    Post(author: "teddyphotos", description: "My most in-depth interview in the last 6 years for the worldwide cover of @rollingstone, this one got deep and very emotional. Link in stories × @lizcollinsphotographer", image: "teddyphotos_post2", likes: 355_207, views: 400_143),
    Post(author: "teddyphotos", description: "I had a very good time", image: "teddyphotos_post3", likes: 544_086, views: 700_334),
    
    Post(author: "joebiden", description: "I know there are millions today who feel angry because of the Court's decision. Hope was on the horizon thanks to our relief plan, and today's decision snatches it away.", image: "joebiden_post1", likes: 20_816, views: 45_433),
    Post(author: "joebiden", description: "All Americans deserve the peace of mind that if an illness strikes or an accident occurs, you can get the care you need. My Administration is committed to expanding access to affordable health care and lowering prescription drug costs.", image: "joebiden_post2", likes: 17_115, views: 30_213),
    Post(author: "joebiden", description: "My economic plan is a blue-collar blueprint to rebuild America", image: "joebiden_post3", likes: 11_355, views: 20_124),
    
    Post(author: "tim_cook", description: "What an incredible week in India! Thanks to our teams across the country. I can't wait to return! 🙏🇮🇳", image: "tim_cook_post1", likes: 52_316, views: 2_900_231),
    Post(author: "tim_cook", description: "'The Astronaut and His Parrot' is a story of hope and connection. Today, I met one of India's best sci-fi filmmakers @AratiKadav, who created this beautiful award-winning short film using only her iPhone and MacBook Pro.", image: "tim_cook_post2", likes: 11_816, views: 645_433),
    Post(author: "tim_cook", description: "It's great to see so many developers across India pursuing their passion and sharing their ideas with users around the world. I had the pleasure of meeting Hitwicket, India's top-rated cricket app, Prayoga, an AR-based yoga app, and LookUp, an easy to use dictionary app! 🏏🧘🏼📖", image: "tim_cook_post3", likes: 12_816, views: 899_433),

    Post(author: "ryantedder", description: "Only took 15 years of touring to figure out how to do it right. @onerepublic 🫠🏝️🤷‍♂️🤘🏽❤️", image: "ryantedder_post1", likes: 38_936, views: 128_975),
    Post(author: "ryantedder", description: "Breaking Bad the MUSICAL fam. Secrets out. Whew. So hard keeping this one quiet 🤦‍♂️", image: "ryantedder_post2", likes: 20_816, views: 45_433),
    
    Post(author: "billieeilish", description: "", image: "billieeilish_post1", likes: 20_816, views: 45_433),
    Post(author: "billieeilish", description: "", image: "billieeilish_post2", likes: 20_816, views: 45_433),
    Post(author: "billieeilish", description: "", image: "billieeilish_post3", likes: 20_816, views: 45_433),
    
    Post(author: "ijustine", description: "", image: "ijustine_post1", likes: 20_816, views: 45_433),
    Post(author: "ijustine", description: "", image: "ijustine_post2", likes: 20_816, views: 45_433),
    Post(author: "ijustine", description: "", image: "ijustine_post3", likes: 20_816, views: 45_433),

    Post(author: "mkbhd", description: "", image: "ijustine_post1", likes: 20_816, views: 45_433),
    Post(author: "mkbhd", description: "", image: "ijustine_post2", likes: 20_816, views: 45_433),
    Post(author: "mkbhd", description: "", image: "ijustine_post3", likes: 20_816, views: 45_433),
].shuffled()
