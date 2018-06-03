Introduction: project 8 - Machine learning

I used the libraries caret, ggplot2, GGally and gbm. Firstly importing the data, into training and testing set. I then make sure that all variables is either a factor or numeric variables, also removing all columns with zero variance.

Further i then set aside about 25% of the data for a validation set. this is to check that no over fitting is happening and that the models hold true on unseen data.

Cross validation techniques were used as part of the modelling. Splitting the data into 6 folds and repeating the exercise twice.

Two models were tested random forest and gradient boosting. Giving very similar results on the validation set. Random forest had slight edge on the confusion matrix. Confusion matrix classification matrix was the key measure of validation that the models are holding true. The models performed exceptionally well with an accuracy of 99,8%. thus with almost complete certainty the outcome can be predicted.

Lastly it was run on the testing set and the results from the exercise gave 20/20 results.
