library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
library(stringr)
library(wordcloud)
library(reshape2)
library(widyr)
library(tidyr)
canada <- read.csv(file="E:/neha/studies/trent study material/Data Visualisation/canada.csv", header=TRUE)
head(canada)
# Tokenising and cleaning
token.pattern <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
clean.pattern = "https|la|mfclzsfjjr|de|tco|en|amp|[[:cntrl:]]|\\'|\\!\\,|\\?|\\.|\\:"

# Cleaning the dataset
clean.tweets <- canada %>% 
  select(text, country, source)%>%
  mutate(text=iconv(text, "latin1", "ASCII", "")) %>%
  mutate(text=str_replace_all(text,clean.pattern, "")) %>%
  mutate(text=str_replace_all(text,"tco","")) %>%
  mutate(text=tolower(text))

# tokenizing the text column 
tidy.all <- clean.tweets %>% 
  unnest_tokens(word, text, token = "ngrams", n=2) %>%
  filter(!word %in% stop_words$word,
         str_detect(word, "[a-z]"))

tidy.all %>%
  count(word, sort = TRUE)

canada_tweets_separated_words <- tidy.all %>%
  separate(word, c("word1", "word2"), sep = " ")

canada_tweets_filtered <- canada_tweets_separated_words %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
canada_words_counts <- canada_tweets_filtered %>%
  count(word1, word2, sort = TRUE)

# plot canada day word network
canada_words_counts %>%
  filter(n >= 18) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Tweets using the hashtag - Oh Canada",
       subtitle = "Text mining twitter data ",
       x = "", y = "")