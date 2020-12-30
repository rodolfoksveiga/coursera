# notes ####
# regression trees
  # training process
    # split variables into groups
    # evaluate homogeneity/purity within each group
    # split it again
    # stops when the groups are sufficiently homogeneous
  # data transformation are not so useful
  # pros
    # easy to interpret
    # fits non-linear problems
  # cons
    # easy to overfit
      # use pruning/cross-validation to avoid it
    # hard to estimate uncertainty
    # results may vary
# bagging (bootstrap aggregating)
  # resample cases and recalculate predictions
  # very useful for non-linear problems
  # often coupled with trees (random forests)
# random forest
  # training process
    # bootstrap samples
    # at each split, bootstrap variables
    # grow multiple trees and evaluate
  # pros
    # high accuracy
  # pros
    # slow
    # hard to interpretate
    # easy to overfit
  # it's very important to use cross-validation to avoid overfitting
  # one of the top performing algorithms
# boosting
  # training process
    # take a lot of weak predictors
    # weight and add them up (using mean or other aggregation techniques)
    # get a stronger predictor
  # one of the top performing algorithms
# model based prediction
  # training process
    # assume data follow a probabilistic model
    # use baye's theorem to identify optimal classifiers
  # pros
    # take advantage of structure of the data
    # it's computationally cheap
  # cons
    # make additional assumptions about the data
