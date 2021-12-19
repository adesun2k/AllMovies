# AllMovies App
This app connects to an external API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) to asynchronously get all the movies ever created about Batman, the Marvel superhero and persist them to a locally database 
and users can search for any movie by Title, Year, etc. 
App also gets new movies about batman to ensure local database is up to date.

"Choice of a 3rd party"

SwiftyJSON

Pros: 
I love how easy SwiftyJSON makes JSON parsing! It automatically ensures a safe value gets returned even if the data is missing or broken. 
For example, json["search"]["title"].stringValue will either return the movie title as a string or an empty string, regardless of what the JSON contains. 
So if "title" or "year" don't exist, or if they do exist but actually contains an integer for some reason, I'll get back an empty string – it makes JSON parsing extremely safe while being easy to read and write.

Cons: 
Vendor lock-in

SDWebImage

Pros: 
SDWebImage loads the images in a background thread so am not blocking the UI/main thread when this downloading is going on. Furthermore, it will also disk-cache all the images I've downloaded 
and will NEVER re-download an image from the same URL so it saves user's data.

Cons: 
Vendor lock-in

UITest: 

I Did a UITest in the AllMoviesUITests class to ensure app is rendering welll via the testAppWorking() test method.

Favorite Movies:

Although all movies data are persisted locally in the database thereby making data available between app session (i.e closing and reopening the app). 
I was unable to specifically build a feature that let User to save favorite movies or make a movie their favourite beacuse I had busy work week migrating our app to Android 12 and ensuring Android 12 behavioural changes are effected.



The API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) end point to get multiple movies only returns 10 movies per page so I paginated the query to ensure it works well.

The API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) end point returns data in the format for multiple data 
{
    "Search":[{
    "Title":"Batman Begins",
    "Year":"2005",
    "imdbID":"tt0372784",
    "Type":"movie",
    "Poster":"https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"
    },
    ...
    ],"totalResults":"490","Response":"True"
    } 
    
    AND NOT EXACTLY IN THIS FORMAT {"Title":"Batman",
    "Year":"1989",
    "Rated":"PG-13",
    "Released":"23 Jun 1989",
    "Runtime":"126 min",
    "Genre":"Action,
     Adventure",
     "Director":"Tim Burton",
     "Writer":"Bob Kane, Sam Hamm, Warren Skaaren",
     "Actors":"Michael Keaton, Jack Nicholson, Kim Basinger",
     "Plot":"The Dark Knight of Gotham City begins his war on crime with his first major enemy being Jack Napier, a criminal who becomes the clownishly homicidal Joker.",
     "Language":"English, French, Spanish",
     "Country":"United States, United Kingdom",
     "Awards":"Won 1 Oscar. 9 wins & 26 nominations total",
     "Poster":"https://m.media-amazon.com/images/M/MV5BMTYwNjAyODIyMF5BMl5BanBnXkFtZTYwNDMwMDk2._V1_SX300.jpg",
     "Ratings":[{"Source":"Internet Movie Database","Value":"7.5/10"},{"Source":"Rotten Tomatoes","Value":"71%"},{"Source":"Metacritic","Value":"69/100"}],
     "Metascore":"69",
     "imdbRating":"7.5",
     "imdbVotes":"354,693",
     "imdbID":"tt0096895",
     "Type":"movie","DVD":"22 Aug 1997",
     "BoxOffice":"$251,348,343",
     "Production":"N/A",
     "Website":"N/A",
     "Response":"True"}
