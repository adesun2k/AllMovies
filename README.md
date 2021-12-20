# AllMovies App
This app connects to an external API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) to asynchronously get all the movies ever created about Batman, the Marvel superhero and persist them to a local database and users can search for any movie by Title, Year, etc. It also ensures local database is up to date.


## Choice of a 3rd party

## SwiftyJSON

Pros: 
I love how easy SwiftyJSON makes JSON parsing! It automatically ensures a safe value gets returned even if the data is missing or broken. 
For example, json["search"]["title"].stringValue will either return the movie title as a string or an empty string, regardless of what the JSON contains. 
So if "title" or "year" don't exist, or if they do exist but actually contains an integer for some reason, I'll get back an empty string – it makes JSON parsing extremely safe while being easy to read and write.

Cons: 
Vendor lock-in

## SDWebImage

Pros: 
SDWebImage loads the images in a background thread so am not blocking the UI/main thread when this downloading is going on. Furthermore, it will also disk-cache all the images I've downloaded 
and will NEVER re-download an image from the same URL so it saves user's data.

Cons: 
Vendor lock-in

## UITest: 

I Did a UITest in the AllMoviesUITests class to ensure app is rendering welll via the testAppWorking() test method.

Favorite Movies:

Although all movies data are persisted locally in the database thereby making data available between app session (i.e closing and reopening the app). 
I was unable to specifically build a feature that let User to save favorite movies or make a movie their favourite beacuse I had busy work week migrating our app to Android 12 and ensuring Android 12 behavioural changes are effected.



The API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) end point to get multiple movies only returns 10 movies per page so I paginated the query to ensure it works well.

![This is an image](https://github.com/adesun2k/AllMovies/blob/main/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20Max%20-%202021-12-18%20at%2009.57.20.png)
![This is an image](https://github.com/adesun2k/AllMovies/blob/main/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20Max%20-%202021-12-18%20at%2009.57.31.png)

## The API(https://www.omdbapi.com/?s=Batman&page=1&apikey=86c4b2d9) end point returns data in this format for multiple data 

```{
    "Search":
    [
    {
        "Title":"Batman Begins","Year":"2005","imdbID":"tt0372784","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"
    },
    {
        "Title":"Batman v Superman: Dawn of Justice","Year":"2016","imdbID":"tt2975590","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYThjYzcyYzItNTVjNy00NDk0LTgwMWQtYjMwNmNlNWJhMzMyXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"
    },
    {
        "Title":"Batman","Year":"1989","imdbID":"tt0096895","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMTYwNjAyODIyMF5BMl5BanBnXkFtZTYwNDMwMDk2._V1_SX300.jpg"
    },
    {
        "Title":"Batman Returns","Year":"1992","imdbID":"tt0103776","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BOGZmYzVkMmItM2NiOS00MDI3LWI4ZWQtMTg0YWZkODRkMmViXkEyXkFqcGdeQXVyODY0NzcxNw@@._V1_SX300.jpg"
    },
    {
        "Title":"Batman Forever","Year":"1995","imdbID":"tt0112462","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BNDdjYmFiYWEtYzBhZS00YTZkLWFlODgtY2I5MDE0NzZmMDljXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg"
    },
    {
        "Title":"Batman & Robin","Year":"1997","imdbID":"tt0118688","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMGQ5YTM1NmMtYmIxYy00N2VmLWJhZTYtN2EwYTY3MWFhOTczXkEyXkFqcGdeQXVyNTA2NTI0MTY@._V1_SX300.jpg"
    },
    {
        "Title":"The Lego Batman Movie","Year":"2017","imdbID":"tt4116284","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMTcyNTEyOTY0M15BMl5BanBnXkFtZTgwOTAyNzU3MDI@._V1_SX300.jpg"
    },
    {
        "Title":"Batman: The Animated Series","Year":"1992–1995","imdbID":"tt0103359","Type":"series","Poster":"https://m.media-amazon.com/images/M/MV5BOTM3MTRkZjQtYjBkMy00YWE1LTkxOTQtNDQyNGY0YjYzNzAzXkEyXkFqcGdeQXVyOTgwMzk1MTA@._V1_SX300.jpg"
    },
    {
        "Title":"Batman: Under the Red Hood","Year":"2010","imdbID":"tt1569923","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BNmY4ZDZjY2UtOWFiYy00MjhjLThmMjctOTQ2NjYxZGRjYmNlL2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"
    },
    {
        "Title":"Batman: The Dark Knight Returns, Part 1","Year":"2012","imdbID":"tt2313197","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMzIxMDkxNDM2M15BMl5BanBnXkFtZTcwMDA5ODY1OQ@@._V1_SX300.jpg"
    }
    ],
    "totalResults":"490",
    "Response":"True"
}

    
   ## AND NOT EXACTLY IN THIS FORMAT 
   {
   "Title":"Batman",
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
     "Response":"True"
     }```

