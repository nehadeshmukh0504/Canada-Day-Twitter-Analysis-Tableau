#The code used to collect your tweets should go here
library(twitteR)
library(streamR)
library(ROAuth)
## install devtools package if it's not already
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
## install dev version of rtweet from github
devtools::install_github("mkearney/rtweet")

## load rtweet package
library(rtweet)

#Authentication for rTweet
create_token(
  app = "rtweet_token",
  consumer_key = "TaEfmfVnuKODi9N5H00AmH3Gu",
  consumer_secret = "MiUzqheRhgP789bphr38tqdZTxCOXTuFWg4MlWM1c3JWJRSpgs",
  access_token = "1067108927907786753-MMymmV9akRi5BUqZX2P1Ua16XqfPLk",
  access_secret = "jiLlaL1jEqXwRPgfm5e9CqB3xGhX0G6o7Y5EdgMa0EvnB")

#Authentication using StreamR

consumerKey <- "TaEfmfVnuKODi9N5H00AmH3Gu" 
consumerSecret <- "MiUzqheRhgP789bphr38tqdZTxCOXTuFWg4MlWM1c3JWJRSpgs" 
accessToken = "1067108927907786753-MMymmV9akRi5BUqZX2P1Ua16XqfPLk"
accessTokenSecret = "jiLlaL1jEqXwRPgfm5e9CqB3xGhX0G6o7Y5EdgMa0EvnB"

oAuthToken <- createOAuthToken(consumerKey, consumerSecret, accessToken, accessTokenSecret)

#Pulling historical data from twitter
rt <- search_tweets("#OhCanada", n = 10000, language = "en", include_rts = FALSE)
rt
View(rt)

#Pulling streaming data from twitter
stream_tweets("#OhCanada",timeout = 60 * 60 * 6,
              file_name = "canada.json",
              parse = FALSE
)

canada <- parse_stream("canada.json")

#Adding an extra column for the method in rt dataframe
library(dplyr)
rt %>% mutate(Method = "REST technique")
#Adding an extra column for method in Mars1 dataframe
canada %>% mutate(Method = "Streaming API")
View(canada)
#Merge both dataframes
canada <- rbind(rt, canada)
canada

#Dataframe to CSV
library(data.table)
fwrite(canada, file = "E:/neha/studies/trent study material/Data Analysis with R/canada.csv")