# R-helper
R helper functions

####%!in%
*    blank not in blank 

####rand()
*    random version of head() or tail()

####tapply.matrix()
*    apply tapply to a matrix

####a.n
*    shorten as.numeric()

####a.c
*    shorten as.character()

####len
*    shorten length()

####last
*    return last value of vector

####unlistSplit
*    split vector(vec) string by(sep) and return matrix

####invert
*    turns ones to zeros zeros to ones

####getScoreNorm
*    get proper predictive score for model fit from Gneiting and Raferty

####spline.poly
*    fit a smooth spline around data like you would a convex hull

####distance
*    gives distances between an (x,y) point  and an (x,y) matrix


####angleTo
*     angle in degrees between (x,y) and (x,y) matrix from the x-axis -90 to 90 


####spatialQuant 
*    calculate the a quantile in 2D at binned angles from the median

SpatialQuant() and spline.poly() were used to draw the 95% bounding box around the inner point cloud 
![Image](https://cloud.githubusercontent.com/assets/6601105/7544206/14c7095a-f599-11e4-824b-8082e9256fb2.png?raw=true)

####Fuzzy MATCH 
fuzWHICH()
*    Return the closest match to a a value

####Local minimums and maximums
localMS()
*    Returns the index of max or min 
*    'which.max' number needs to be middle of odd roll num

####Make z-scores
*    Subtracts the mean and divides by standard deviations

