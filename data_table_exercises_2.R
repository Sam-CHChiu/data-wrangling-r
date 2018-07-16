########################################################################
#              data.table Exercises - By Sam Chiu                     
# Dataset            : Wine quality (external)
# Utilized Packages  : data.table
# Utilized Techniques: data.table techniques
# Exercise Source    : https://www.r-bloggers.com/data-table-exercises-keys-and-subsetting/
########################################################################

rm(list=ls())
library(data.table)
df = fread("~/Documents/winequality-white.csv") # faster than read.table or read.csv

# Exercise 1
# Repeat to 4.8 million records
df = df[rep(1:nrow(df), 1000)]

# Exercise 2 
haskey(df) # check whether there's a key or not
setkey(df, quality) # If not, then set Quality as key
key(df)

# Exercise 3
# Create a new data.table df2, containing the subset of df with quality equal to 9.
df2 <- df[quality == 9] # my solution
df2 <- df[.(9)] # official solution

# Exercise 4
# Remove the key from df, and repeat exercise 3. How much slower is this?
setkey(df, NULL)
key(df)
system.time(df2 <- df[quality == 9])

# Exercise 5
# Create a new data.table df2, containing the subset of df with quality equal to 7, 8 or 9. 
# First without setting keys, 
setkey(df, NULL)
system.time(df2 <- df[quality %in% c(7,8,9)])
#then with setting keys and compare run-time.
setkey(df, quality)
system.time(df2 <- df[.(c(7,8,9))])

# Exercise 6
# Create a new data.table df3 containing the subset of observations from df with:
# fixed acidity < 8 and residual sugar < 5 and pH < 3. 
# First without setting keys, 
setkey(df, NULL)
system.time(df3 <- df[`fixed acidity`<8 & `residual sugar`<5 & pH<3])
# then with setting keys and compare run-time. Explain why differences are small.
setkey(df, `fixed acidity`, `residual sugar`, pH)
system.time(df3 <- df[`fixed acidity`<8 & `residual sugar`<5 & pH<3])

# Exercise 7
# Take a bootstrap sample (i.e., with replacement) of the full df data.table without keys, and record run-time. 
setDT(df)
setkey(df, NULL)
system.time(df3 <- df[sample(.N, .N, replace = T)])

# Then, convert to a regular data frame, and repeat. 
setDF(df)
system.time(df3 <- df[sample(nrow(df), nrow(df), replace = T),]) 

# What is the difference in speed? 

## answer: much slower on a data.frame object

# Is there any (speed) benefit in creating a new variable id equal to the row number, creating a key for this variable, and use this key to select the bootstrap?
df$id <- 1:nrow(df)
df <- data.table(df, key='id')
system.time(df3 <- df[.(sample(.N, .N, replace=TRUE))])  ## slower than without key
