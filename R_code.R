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


<<<<<<< HEAD
## 1. Split the data - test/train 
set.seed(12)
inTrain.clean = createDataPartition(sonar.clean$Class, p = 0.8, list = F) #stratified according to variable
sonar.clean.train = sonar.clean %>% dplyr::slice(as.vector(inTrain.clean))
sonar.clean.test = sonar.clean %>% dplyr::slice(as.vector(-inTrain.clean))

## 2. Generate my grid
# mtry 
# splitrule
# min.node size

## 3. Specify values for hyper-parameters
# mtry --> generally start with approximately square-root of parameters (60 parameters) (?ranger --> mtry)
sqrt(60) #7.75
my.mtry = c(4, 7, 10)

# splitrule  
my.rule = "gini"

# min.node.size --> default is 1 for classification 
my.nodes = c(1, 3, 5)

# create tuning grid 
#creates grid of all combinations 
my.grid = expand.grid(mtry = my.mtry,
                      splitrule = my.rule,
                      min.node.size = my.nodes)
my.grid 

## 4. Define evaluation metric 
my.metric = "Accuracy"

## 5. Train model over hyperparameters 
set.seed(12) 
rf.tune = caret::train(Class ~ ., data = sonar.clean.train, method = "ranger"
                       , metric = my.metric
                       , importance = "impurity" 
                       , trControl = trainControl(classProbs =  T,
                                                  method = "cv",
                                                  number = 10)
                       , tuneGrid = my.grid # grid of hyperparameters
)
rf.tune$results %>% arrange(desc(Accuracy))

## 6. Select best hyperparameters based on evaluation metric 
rf.tune$bestTune


## 7. Use tuned model to predict test sample 
pred.tune = predict(rf.tune, sonar.clean.test, type = 'raw') #class predictions
head(pred.tune)

pred.tune.prob = predict(rf.tune, sonar.test, type = 'prob') #probability predictions
head(pred.tune.prob)
=======
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
>>>>>>> 4ed479a3dc41b1eb150589ca11c0ee7169b2b284

