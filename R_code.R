### LIBRARIES
library(tidyverse)
library(caret)
library(ROCR)
library(ranger) #we'll use for our RF model
library(mlbench) #some good built-in data sets

### DATA 
# Sonar data
data(Sonar)
str(Sonar) # 60 variables (sensors), and 1 classification factor 

# Class - M (metal) or R (rock) 
levels(Sonar$Class)
Sonar %>% count(Class) %>% mutate(prop = n / sum(n)) 
