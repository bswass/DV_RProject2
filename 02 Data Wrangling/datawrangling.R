require("jsonlite")
require("RCurl")
# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelpbusiness"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_crp2426', PASS='orcl_crp2426', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary (df)
head(df)

require(tidyr)
require(dplyr)
require(ggplot2)

df %>% select(STARS, STATE, REVIEW_COUNT, ATTR_MUSIC_KARAOKE, ATTR_NOISE_LEVEL) %>% filter(ATTR_MUSIC_KARAOKE != "null", ATTR_NOISE_LEVEL != "null") %>% ggplot(aes(x=STARS, y=REVIEW_COUNT, color=ATTR_NOISE_LEVEL)) + geom_point() + facet_wrap(~ATTR_MUSIC_KARAOKE)

df %>% select(STARS, STATE, REVIEW_COUNT, ATTR_MUSIC_KARAOKE, ATTR_NOISE_LEVEL) %>% filter(ATTR_MUSIC_KARAOKE != "null", ATTR_NOISE_LEVEL != "null") %>% ggplot(aes(x=ATTR_NOISE_LEVEL, y=REVIEW_COUNT, color=STARS)) + geom_point() + facet_wrap(~ATTR_MUSIC_KARAOKE)


#df %>% filter(ATTR_GOOD_FOR_BREAKFAST != "null"| ATTR_GOOD_FOR_LUNCH != "null"| ATTR_GOOD_FOR_BRUNCH != "null"| ATTR_GOOD_FOR_DINNER != "null"| ATTR_GOOD_FOR_LATENIGHT != "null") %>% group_by(ATTR_GOOD_FOR_BREAKFAST, ATTR_GOOD_FOR_LUNCH, ATTR_GOOD_FOR_BRUNCH, ATTR_GOOD_FOR_DINNER, ATTR_GOOD_FOR_LATENIGHT) %>% summarize(avg = mean(STARS), n = n()) %>% ggplot(aes(x=avg, y=n)) + geom_point() + facet_wrap(~ATTR_GOOD_FOR_BREAKFAST + ATTR_GOOD_FOR_LUNCH)
  
#df %>% mutate(star_percent = cume_dist(STARS)) %>% filter(star_percent >.50) %>% ggplot(aes(x=STARS, y=REVIEW_COUNT)) + geom_point()
