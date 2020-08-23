## BY: Rodolfo Veiga
## DATE: 16/08/2020

# makeCacheMatrix () ####
# concatenates a sequence of functions to set and retrieve
# the values of the original matrix and its inverse and to
# further cache them
makeCacheMatrix <- function(x = matrix()) {
  # sets the inverse matrix as 'NULL' though, since the
  # ivnerse matrix wasn't cached yet
  inv <- NULL
  # sets the value of the original matrix
  set <- function(y) {
    x <<- y
    inv <<- NULL
  }
  # gets the value of the original matrix
  get <- function() x
  # sets the value of the inverse matrix
  setinverse <- function(inverse) inv <<- inverse
  # gets the value of the inverse matrix
  getinverse <- function() inv
  # concatenates and returns all the functions into a single list
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}

# cacheInverse() ####
# returns the cached inverse of a matrix or calculates the
# inverse of a matrix and cache it to retrieve it later
cacheSolve <- function(x, ...) {
  # tries to get the value of a cached inverse matrix
  inv <- x$getinverse()
  # if the value of the matrix isn't 'NULL', which means it
  # was cached before, it prints the message below
  if(!is.null(inv)) {
    # prints the message
    message("getting cached data")
    return(inv)
  }
  # if the value of the matrix is 'NULL', which means it
  # wasn't cached before, it calculates the inverse matrix
  # gets the original matrix
  data <- x$get()
  # calculates the inverse matrix
  inv <- solve(data, ...)
  # sets the inverse matrix so it's stored in the
  # makeCacheMatrix() environment, which means it's
  # stored in R environment cache
  x$setinverse(inv)
  # returns the inverse matrix
  inv
}
