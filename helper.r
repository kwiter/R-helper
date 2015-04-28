#### NOT IN

'%!in%' <- function(x,y)!('%in%'(x,y)) #not in

#### random section of matrix random version of head() or tail()

rand <- function(matrix,n=6){ # random version of head
  seed <- sample(1:dim(matrix)[1],1)
  xx <- matrix[seed:(seed+n),]
  rownames(xx) <- seed:(seed+n)
  xx
} 

############### apply tapply to a matrix
tapply.matrix <- function(mat,index,funct){ #tapply on matrix mckFUNCTIONS
  apply(mat,2,function(x){ tapply(x,index,funct,na.rm=T)})  
}

#short as .numeric
a.n <- function(x){as.numeric(x)}#short as.numeric

#short as.character
a.c <- function(x){as.character(x)}#short as.character

##shorten Length
len <- function(x){length(x)}

#return last value
last <- function(vec){rev(vec)[1]}

#split vector string and return matrix
unlistSplit = function(vec,sep="-"){
  matrix(unlist(strsplit(vec,split=sep)),nrow = length(vec),ncol=str_count(vec[1],sep)+1,byrow=T)
}

#proper predictive score
getScoreNorm <- function(x,mu,xvar){
  # Gneiting and Raferty's proper scoring rule
  # outcome x, prediction mean and variance (mu, xvar)
  #higher scores are better
  - ( (x - mu)^2)/xvar - log(xvar)
}

#
# Splining a polygon.
#
#   The rows of 'xy' give coordinates of the boundary vertices, in order.
#   'vertices' is the number of spline vertices to create.
#   'k' is the number of points to wrap around the ends to obtain
#       a smooth periodic spline.
#
#   Returns an array of points. 
# 
spline.poly <- function(xy, vertices, k=3, ...) {
  # Assert: xy is an n by 2 matrix with n >= k.
  
  # Wrap k vertices around each end.
  n <- dim(xy)[1]
  if (k >= 1) {
    data <- rbind(xy[(n-k+1):n,], xy, xy[1:k, ])
  } else {
    data <- xy
  }
  
  # Spline the x and y coordinates.
  data.spline <- spline(1:(n+2*k), data[,1], n=vertices, ...)
  x <- data.spline$x
  x1 <- data.spline$y
  x2 <- spline(1:(n+2*k), data[,2], n=vertices, ...)$y
  
  # Retain only the middle part.
  cbind(x1, x2)[k < x & x <= n+k, ]
}

#distance between (x,y) and (x,y) matrix
distance = function(valM,M){
  
  sqrt((M[,1]-valM[1])^2 + (M[,2]-valM[2])^2) 
  
}

