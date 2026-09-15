### LIBRARIES
library(tidyverse)
library(caret)
library(ROCR)
library(ranger)
library(mlbench) 

### DATA 
# Sonar data
data(Sonar)
str(Sonar) # 60 variables (sensors), and 1 classification factor 

# Class - M (metal) or R (rock) 
levels(Sonar$Class)
Sonar %>% count(Class) %>% mutate(prop = n / sum(n)) 

# Training and Testing Split (80/20)
set.seed(12)
inTrain = createDataPartition(Sonar$Class, p = 0.8, list = F) 

sonar.train = Sonar %>% dplyr::slice(as.vector(inTrain))
sonar.test = Sonar %>% dplyr::slice(as.vector(-inTrain))

#both have similar Class proportions to original 
sonar.train %>% count(Class) %>% mutate(prop = n / sum(n)) 
sonar.test %>% count(Class) %>% mutate(prop = n / sum(n)) 


### CARET - DEFAULT TRAINING 
set.seed(12)
rf = caret::train(Class ~ ., data = sonar.train, method = "ranger")
rf
rf$bestTune


## Confusion Matrix
pred = predict(rf, sonar.test, type = "raw") 
conf = table(actual = sonar.test$Class, pred)
conf
# TP FN
# FP TN 

# Accuracy (test sample)
acc = sum(diag(conf))/sum(conf)
acc 

# Confusion Matrix ... the easy way (using caret)
conf2 = caret::confusionMatrix(data = pred, reference = sonar.test$Class)
conf2
t(conf2$table) 


## CV (Repeated CV)
set.seed(12)
rf.cv = caret::train(Class ~ ., data = sonar.train, method = "ranger"
                     , trControl = trainControl(method = "cv", number = 10) # 10-fold CV
)
rf.cv 


## EVALUATION METRIC 
set.seed(12)
rf.kap = caret::train(Class ~ ., data = sonar.train, method = "ranger"
                      , metric = "Kappa" #example using kappa instead
                      , trControl = trainControl(method = "cv", number = 10)
)
rf.kap


## CLASS PROBABILITIES
predict(rf.kap, sonar.test, type = "prob") # why didn't this work? 

?caret::trainControl # classProbs = FALSE
rf.prob = caret::train(Class ~ ., data = sonar.train, method = "ranger"
                       , trControl = trainControl(method = "cv", number = 10, classProbs = T) #make classProbs = T
)
rf.prob
prob = predict(rf.prob, sonar.test, type = "prob") #predicted probabilities
head(prob) 
# We can use these to calculate ROC, AUC, and all the other curves like before

