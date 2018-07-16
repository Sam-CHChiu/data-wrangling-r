########################################################################
#              dplyr Exercises - By Sam Chiu                     
# Dataset            : 
# Utilized Packages  : tidyverse
# Utilized Techniques: dplyr techniques
# Exercise Source    : https://www.r-exercises.com/2017/10/19/dplyr-basic-functions-exercises-solutions/
########################################################################
rm(list=ls())

library(tidyverse)

# Exercise 1
# Select the first three columns of the iris dataset using their column names.
iris %>% select(1:3) %>% tbl_df

# Exercise 2
# Select all the columns of the iris dataset except “Petal Width”.
iris %>% select(-Petal.Width) %>% tbl_df

# Exercise 3
# Select all columns of the iris dataset that start with the character string “P”
iris %>% select(matches('^P')) %>% tbl_df

# Exercise 4
# Filter the rows of the iris dataset for Sepal.Length >= 4.6 and Petal.Width >= 0.5
iris %>% filter(Sepal.Length >= 4.6 & Petal.Width >= 0.5) %>% tbl_df

# Exercise 5
# Pipe the iris data frame to the function that will select two columns (Sepal.Width and Sepal.Length).
iris %>% select(Sepal.Width, Sepal.Length) %>% tbl_df

# Exercise 6
# Arrange rows by a particular column, such as the Sepal.Width.
iris %>% arrange(Sepal.Width) %>% tbl_df

# Exercise 7
# Select three columns from iris, arrange the rows by Sepal.Length, then arrange the rows by Sepal.Width
iris %>% select(Sepal.Length, Sepal.Width, Species) %>% arrange(Sepal.Length, Sepal.Width) %>% tbl_df

# Exercise 8
# Create a new column called proportion, which is the ratio of Sepal.Length to Sepal.Width.
iris %>% mutate(proportion = Sepal.Length/Sepal.Width) %>% tbl_df

# Exercise 9
# Compute the average number of Sepal.Length, apply the mean() function to the column Sepal.Length, and call the summary value “avg_slength”.
iris %>% summarise(avg_slength = mean(Sepal.Length))

# Exercise 10
# Split the iris data frame by the Sepal.Length, then ask for the same summary statistics as above.
### The question doesn't make sense. Should be group by species.
iris %>% group_by(Species) %>% summarise(avg_slength = mean(Sepal.Length)) %>% tbl_df
