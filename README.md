# H-RANSAC
## General idea
A generalized implementation of RANSAC (Random Sample Consensus), $H$-RANSAC, for homography estimation. In this implementation, two logical tests (one ad-hoc and one post-hoc) are used based on the geometry of random selected points on each iteration. The necessary iterations of the algorithm are calculated and homography matrix, $H$, is estimated.
Code is provided both in Python and MATLAB.

## Ad-hoc and post-hoc criteria
In order to retrieve homography image transformations from sets of points without descriptive local feature vectors to allow for point pairing, we introduce two logical criteria. We propose a robust criterion that rejects implausible point selection before each iteration of RANSAC, based on the type of the quadrilaterals formed by random point pair selection (convex or concave and (non)-self-intersecting). To cover some practical applications we allow the points to be (optionally) labelled in two classes. Also, a similar post-hoc criterion rejects implausible homography transformations is included at the end of each iteration.
Both criteria are calculating the value Q, based on the below equations, for each shaped quadrilateral

$Q=|\sum_{i} sgn(v^i_z)|, i=1,2,3,4$,

where

$v^i=(p_i-p_p) \times (p_n-p_i)$, 

with $p_p, p_n$ be the previous and next edges that shapes two consecutive vertices with edge $p_i$

An example of different Q values, is depicted on the below figure.

<img src="sources/Q_figure.png" width="50%">

## Number of estimated iterations
