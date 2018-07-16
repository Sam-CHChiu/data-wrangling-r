########################################################################
#              tidyr Exercises - By Sam Chiu                     
# Dataset            : 
# Utilized Packages  : tidyr, dplyr, ggplot2
# Utilized Techniques: tidyr techniques
# Exercise Source    : https://www.r-exercises.com/2017/11/02/how-to-tidy-up-your-dataset-exercises/
########################################################################
rm(list=ls())

library(tidyr)
library(dplyr)
library(ggplot2)

## Build the dataset (from the website)
nba <- data.frame(
  player = c("James", "Durant", "Curry", "Harden", "Paul", "Wade"),
  team = c("CLEOH", "GSWOAK", "GSWOAK", "HOUTX", "HOUTX", "CLEOH"),
  day1points = c("25","23","30","41","26","20"),
  day2points = c("24","25","33","45","26","23")
)

# Exercise 1
# Gather “day1points” and “day2points” into a new column “day” and their values to a new column named “points”.
nba_ex1 = gather(nba, day, points, c(day1points, day2points))
tbl_df(nba_ex1)

#E xercise 2
# Reverse the position of day and points to understand the significance of their initial position.
nba_ex2 = gather(nba, points, day, c(day1points, day2points))
tbl_df(nba_ex2)

# Exercise 3
# Reverse what you did in Exercise 1 by giving to the dataset its initial form.
nba_ex3 = spread(nba_ex1, day, points)
tbl_df(nba_ex3)

# Exercise 4
# Reverse the position of “day” and “points” in the answer of Exercise 3 to understand why the code is not working.
spread(nba_ex1, points, day) # Error reason: duplicate identifiers (row 5, 11)

# Exercise 5
# Create two columns one for the “team” and the other for the “state” from the column “team”. Set the sep to 3.
nba_ex5 = nba %>% 
  gather(day, points, c(day1points, day2points)) %>% 
    separate(team, c('team', 'state'), sep = 3)
tbl_df(nba_ex5)

# Exercise 6
# Change the sep argument from 3 to 2 and find the mistake.
nba_ex6 = nba %>% 
  gather(day, points, c(day1points, day2points)) %>% 
  separate(team, c('team', 'state'), sep = 2) # Miskake: wrong sep length
tbl_df(nba_ex6)

# Exercise 7
# Unite the two columns you created in Exercise 6 to one as its intial form.
nba_ex7 = unite(nba_ex6, team, c(team, state), sep = '')
tbl_df(nba_ex7)

# Exercise 8
# Use the right commands to tidy up your dataset by creating 5 columns: “player”, “Team”, “State”, “day” and “points”.
nba_ex8 = nba %>% separate(team, c('Team', 'State'), sep = 3) %>% gather(day, points, c(day1points, day2points))
tbl_df(nba_ex8)

# Exercise 9
# Plot your dataset by creating a scatterplot with day in x-axis and points in y-axis
ggplot(nba_ex8, aes(x = day, y = points)) + geom_point()

# Exercise 10
# Separate the plot of Exercise 9 according to “Team”
ggplot(nba_ex8, aes(x = day, y = points)) + geom_point() + facet_wrap(~ Team)
