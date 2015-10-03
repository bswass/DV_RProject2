require("jsonlite")
require("RCurl")
# Change the USER and PASS below to be your UTEid
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelpbusiness"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_crp2426', PASS='orcl_crp2426', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
summary (df)
head(df)

require(tidyr)
require(dplyr)
require(ggplot2)


" The first set of data wrangling operations starts with selecting the number of stars the business got, number of reviews for the specific busisness, whether the business has karaoke music, and the level of noise in the business. Then filter out the nulls in the attributes because it provides no useful info. Lastly, create a plot with the x value being the number of stars, y value being the number of reviews, color value being the levels of noise, and lastly split the plot into 2 with one being that no karaoke music and the other being that there is karaoke music."
" The reason that this visual is interesting is because it shows that businesses without karaoke music get a much higher number of reviews and more stars than businesses with karaoke. Furthermore, the noise level is higher in businesses without karaoke music than businesses with karaoke. Lastly, the businesses with a higher noise level have less stars than businesses with a lower noise level."

df %>% select(STARS, REVIEW_COUNT, ATTR_MUSIC_KARAOKE, ATTR_NOISE_LEVEL) %>% filter(ATTR_MUSIC_KARAOKE != "null", ATTR_NOISE_LEVEL != "null") %>% ggplot(aes(x=STARS, y=REVIEW_COUNT, color=ATTR_NOISE_LEVEL)) + geom_point() + facet_wrap(~ATTR_MUSIC_KARAOKE)


" The second set of data wrangling operations starts with adding a new column to the data which contains the cumulative distribution of the review counts. Then we filter out the nulls in the cater attribute. Lastly, create a plot with the x value being the review distribution, y value being the number of reviews, color value being whether the business had catering or not, and lastly split the plot into 2 with one being that the business is currently open and the other being that the business is currently closed."
" The reason that this visual is interesting is because the review distribution is an exponential distribution also it is interesting that the 90% of the businesses have approximately 1-10 reviews. Furthermore, the businesses that are currently closed have much less reviews that the businesses that are currently open which shows that Yelp is somewhat accurate in telling what business will close down and what will still be open by seeing the number of reviews on yelp. Lastly, it is interesting to see that businesses that don't have catering have a higher number of reviews than businesses that do have catering."

df %>% mutate(review_percent = cume_dist(REVIEW_COUNT)) %>% filter(ATTR_CATERS!="null") %>% ggplot(aes(x=review_percent, y=REVIEW_COUNT, color=ATTR_CATERS)) + geom_point() + facet_wrap(~OPEN)


" The third set of data wrangling operations starts filtering out nulls in the alcohol attribute and the city value. Then the data is grouped together by city and state. Next, the data focuses on the city and state column as well as the new columns Star_Average, which is the average stars that businesses get in the specific city,state, and Num_of_Businesses_per_City, which is the number of business in the specific city,state. Lastly, create a plot with the x value being the Star_Average, y value being the Num_of_Businesses_per_City, and the color value being the State that the businesses are in."
" The reason that this visual is interesting is because it the visual shows a normal distribution for the average number of stars per city with most states having an average star rating as 3.5. Lastly, it shows that all states that have more than a few businesses in its cities has a star average of approximately 3.5."

df %>% filter(CITY!="null", ATTR_ALCOHOL!="null") %>% group_by(CITY, STATE) %>% summarize(Star_Average_per_City=mean(STARS), Num_of_Businesses_per_City=n()) %>% ggplot(aes(x=Star_Average_per_City, y=Num_of_Businesses_per_City, color=STATE)) + geom_point()
