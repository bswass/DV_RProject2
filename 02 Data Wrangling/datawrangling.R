require("jsonlite")
require("RCurl")
# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelpbusiness"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_crp2426', PASS='orcl_crp2426', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary (df)
head(df)

require(tidyr)
require(dplyr)
require(ggplot2)

df %>% select(STARS, REVIEW_COUNT, ATTR_MUSIC_KARAOKE, ATTR_NOISE_LEVEL) %>% filter(ATTR_MUSIC_KARAOKE != "null", ATTR_NOISE_LEVEL != "null") %>% ggplot(aes(x=STARS, y=REVIEW_COUNT, color=ATTR_NOISE_LEVEL)) + geom_point() + facet_wrap(~ATTR_MUSIC_KARAOKE)

df %>% select(STARS, STATE, REVIEW_COUNT, ATTR_MUSIC_KARAOKE, ATTR_NOISE_LEVEL) %>% filter(ATTR_MUSIC_KARAOKE != "null", ATTR_NOISE_LEVEL != "null") %>% ggplot(aes(x=ATTR_NOISE_LEVEL, y=REVIEW_COUNT, color=STARS)) + geom_point() + facet_wrap(~ATTR_MUSIC_KARAOKE)
  
df %>% mutate(review_percent = cume_dist(REVIEW_COUNT)) %>% filter(OPEN!="null", ATTR_CATERS!="null") %>% ggplot(aes(x=review_percent, y=REVIEW_COUNT, color=ATTR_CATERS)) + geom_point() + facet_wrap(~OPEN)

df %>% filter(CITY!="null", ATTR_ALCOHOL!="null") %>% group_by(CITY, STATE) %>% summarize(Star_Average=mean(STARS), Num_of_Businesses_per_City=n()) %>% ggplot(aes(x=Star_Average, y=Num_of_Businesses_per_City, color=STATE)) + geom_point()
