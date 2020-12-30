# notes ####
# hierarchical clustering
  # gives an idea of the relationships between variables/observations
  # the picture may be unstable
    # change a few points
    # have different missing values
    # pick a different distance
    # change the merging strategy
    # change the scale of points for one variable
      # variables with scales too diferent can be a relevant problem
  # it's deterministic!
  # at first place it should be used for data exploration

# k-means clustering
  # partitioning approach
    # 1. fix a number of k clusters
    # 2. get centroids
    # 3. assign points to closest centroid
    # 4. recalculate centroids
  # how do we define close?
    # garbage -> garbage out
    # distance or similarity
      # continuous
        # euclidean distance
        # correlation similary
    # binary (manhattan distance)
  # a number of cluster should be chosen
    # pick by eye/intuition
    # pick by cross-validation/information theory
  # it's not deterministic

# dimension reduction
  # find a new set of multivariate variables that are uncorrelated and explain as much
    # variance as possible (statistical goal)
  # if you put all the variables together in one matrix, find the best matrix created
    # with fewer variables (lower rank) that explains the original data (data compression)
  # svd and pca
    # scale matters!
    # real variables and patterns may be mixed
    # it can be computationally expensive


# course directory ####
course_directory = '~/git/courses/exploratory_data_analysis/'


# 1st, 2nd and 3rd class (hierarchical clustering) ####
# setup environment
setwd(course_directory)

# creates a dataset
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x = rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y = rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))
# calculates the distance between the points
df = data.frame(x, y)
dists = dist(df)
# clusterization
hc = hclust(dists)
# plot dendogram
plot(cluster)
# plot heatmap
mtx = as.matrix(df)
heatmap(mtx)


# 4th and 5th class (k-means clustering) ####
# setup environment
library(datasets)
setwd(course_directory)

# creates a dataset
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x = rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y = rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))
# clusterization
kmc = kmeans(df, centers = 3)
names(kmc)
# plot
par(mar = rep(0.2, 4))
plot(x, y, col = kmc$cluster, pch = 19, cex = 2)
points(kmc$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)


# 6th, 7h and 8th class (dimension reduction) ####
# setup environment
library(datasets)
setwd(course_directory)

# creates a dataset
set.seed(12345)
par(mar = rep(0.2, 4))
mtx = matrix(rnorm(400), nrow = 40)
# add patterns
set.seed(678910)
for (i in 1:40) {
  cf = rbinom(1, size = 1, prob = 0.5)
  if (cf) {
    mtx[i, ] = mtx[i, ] + rep(c(0, 3), each = 5)
  }
}
# plot heatmap
image(1:10, 1:40, t(mtx)[, nrow(mtx):1])
# plot heatmap with "clusters"
par(mar = rep(0.2, 4))
heatmap(mtx)
# hirarchical clusterization
hc = hclust(dist(mtx))
ord_mtx = mtx[hc$order, ]
par(mfrow = c(1, 3), mar = rep(4, 4))
image(t(ord_mtx)[, nrow(ord_mtx):1])
plot(rowMeans(ord_mtx), 40:1, xlab = 'Row Mean', ylab = 'Row', pch = 19)
plot(colMeans(ord_mtx), xlab = 'Column', ylab = 'Column Mean', pch = 19)
# svd
svd1 = svd(scale(ord_mtx))
par(mfrow = c(1, 3))
image(t(ord_mtx)[, nrow(ord_mtx):1])
plot(svd1$u[, 1], 40:1, xlab = 'Row', ylab = 'First left singular vector')
plot(svd1$v[, 1], xlab = 'Column', ylab = 'First right singular vector', pch = 19)
# explain svd variance
par(mfrow = c(1, 2))
plot(svd1$d, xlab = 'Column', ylab = 'Singular value', pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = 'Column', ylab = 'Prop. of variance explained', pch = 19)
# pca and svd are quite the same, as the comparison shows
pca1 = prcomp(ord_mtx, scale = TRUE)
plot(pca1$rotation[, 1], svd1$v[, 1], pch = 19,
     xlab = 'Principal Component 1', ylab = 'Right Singular Vector 1')
abline(c(0, 1))
# simple example
const_mtx = ord_mtx*0
for (i in 1:dim(ord_mtx)[1]) {
  const_mtx[i, ] = rep(c(0, 1), each = 5)
}
# svd
svd2 = svd(const_mtx)
par(mfrow = c(1, 3))
# add first pattern
image(t(const_mtx)[, nrow(const_mtx):1])
plot(svd2$d, xlab = 'Column', ylab = 'Singular value', pch = 19)
plot(svd2$d^2/sum(svd2$d^2), xlab = 'Column', ylab = 'Prop. of variance explained', pch = 19)
# add second pattern
set.seed(678910)
for (i in 1:40) {
  cf1 = rbinom(1, size = 1, prob = 0.5)
  cf2 = rbinom(1, size = 1, prob = 0.5)
  if (cf1) {
    mtx[i, ] = mtx[i, ] + rep(c(0, 5), each = 5)
  }
  if (cf2) {
    mtx[i, ] = mtx[i, ] + rep(c(0, 5), times = 5)
  }
}
hc = hclust(dist(mtx[hc$order, ]))
ord_mtx = mtx[hc$order, ]
# svd
svd3 = svd(scale(ord_mtx))
par(mfrow = c(1, 3))
# plot patterns
image(t(ord_mtx)[, nrow(ord_mtx):1])
plot(rep(c(0, 1), each = 5), pch = 19, xlab = 'Column', ylab = 'Pattern 1')
plot(rep(c(0, 1), times = 5), pch = 19, xlab = 'Column', ylab = 'Pattern 2')
# plot singular vectors
image(t(ord_mtx)[, nrow(ord_mtx):1])
plot(svd3$v[, 1], pch = 19, xlab = 'Column', ylab = 'First right singular vector')
plot(svd3$v[, 2], pch = 19, xlab = 'Column', ylab = 'Second right singular vector')
# svd has problems with missing values
mtx2 = ord_mtx
mtx2[sample(1:100, size = 40, replace = FALSE)] = NA
svd4 = svd(scale(mtx2))
# you can impute values to fill the missing values
library(impute)
mtx2 = ord_mtx
mtx2[sample(1:100, size = 40, replace = FALSE)] = NA
mtx2 = impute.knn(mtx2)$data
svd4 = svd(scale(ord_mtx))
svd5 = svd(scale(mtx2))
par(mfrow = c(1, 2))
plot(svd4$v[, 1], pch = 19)
plot(svd5$v[, 1], pch = 19)


# 9th, 10th, 11th and 12th class (plotting and colour) ####
# setup environment
library(datasets)
setwd(course_directory)

