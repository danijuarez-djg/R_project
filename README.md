In this project I built a Random Forest model to classify an object detected by 60 sonars, we will use the factors Metal and Rock as the classes that our model will classify.

This project was built in R, following the next steps:
  1.- Checking the factors that we will use being Metal our positive class and Metal our negative class.
  2.- Check if our dataset class are balanced or imbalanced to decide the performance metric that I will use.
  3.- Splitting the dataset in training-testing using the rule 80/20.
  4.- Recheck the class proportion of each split.
  5.- Build and train the model with the training split.
  6.- Predict the class on our testing split.
  7.- Check the Confusion Matrix to verify the TP and TN.
  8.- Check the performance metric in this case since the class proportion was balanced, I used the accuracy metric instead of Kappa.
  
  
  
