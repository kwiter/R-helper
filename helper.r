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

