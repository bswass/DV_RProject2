setwd("C:/Users/Chris/Desktop/DataVisualization/DV_RProject2/01 Data")

file_path <- "yelp_academic_dataset_business.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))

# Replace attributes with attr
names(df) <- gsub("attributes", "attr", names(df))

# Replace Ambience with Ambi
names(df) <- gsub("Ambience", "Ambi", names(df))

# Replace Specialized with Spec
names(df) <- gsub("Specialized", "Spec", names(df))

# Replace Dietary_Restrictions with DietRest
names(df) <- gsub("Dietary_Restrictions", "DietRest", names(df))

# Replace Types with blank
names(df) <- gsub("Types", "", names(df))

# Replace Ambience with Ambi
names(df) <- gsub("Hair__Spec", "HairSpec", names(df))

# Replace africanamerican with afam
names(df) <- gsub("africanamerican", "afam", names(df))

# Replace Payment with PayBy
names(df) <- gsub("Payment", "PayBy", names(df))

# Replace straightperms with st8perm
names(df) <- gsub("straightperms", "st8perm", names(df))

# Replace Accessible with Access
names(df) <- gsub("Accessible", "Access", names(df))

# Replace extensions with ext
names(df) <- gsub("extensions", "ext", names(df))

#summary (df)
#str(df)

measures <- c("latitude", "review_count", "stars", "attr_Price_Range", "longitude") 

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}


write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
