# Piecwise-Linear-Model-For-Nonconvex-Classifiers
Classifier for a two-class dataset using only piecewise linear functions. Applicable to any nonlinear non-convex boundary of moderate complexity.

## MATLAB files description
`demo_pwl.m`: This is the main file which loads (different kinds of) data file (.mat) and divides it into training and testing set. Then it calls the `run_sequentially.m` file after setting the parameter m which denotes the number of piecwise linear components in the classifier. 

`run_sequentially.m`: This script calls the `pwl_classifer.m` for each value of m after initializing the model parameters and then calls the plotting script `plot_boundary.m` by passing the output of classifier script. 

`pwl_classifer.m`: This script is the main classifier algorithm which minimizes the huberized hinge loss function using Proximal sub-gradient scheme. The objective function is associated with the general representation of classifier boundary `[Breiman, 93]` in terms of piecewise linear components. 

`plot_boundary.m`: This plotting script first plots the data points from .mat file and then overlays it with the classifier boudnary obtained from final parameters from `pwl_classifier.m`.

`plot_surface.m`: This has same function as `plot_boundary.m` except it is valid for 3-dimensional data.

## List of data files tested
* `Moon_SD.mat`: Well-known moon data set
* `2D_LSD.mat`: linearly separable data
* `2D_PLSD.mat`: Piecewise linearly separable data (2 lines)
* `2D_bendingLineSD.mat`: Data with classfication boudnary containing a hook 
* `2D_diamondSD.mat`: Data with diamond shape classifier boundary
* `2D_circlesSD.mat`: Data separable with a ciruclar boundary
* `2D_polySD.mat`: Polynomially separable data
* `2D_polySD_nw`: Dataset with two-peak polynomial boundary, partially successful in classifying
* `3D_PLSD`: 3-dimensional piecewise linearly separable data.

## Instructions
Start with `demo_pwl.m`. Fix a dataset, choose appropriate choices of parameters and right set of values for m and you are good to go!

## References
Leo Breiman. Hinging hyperplanes for regression, classification, and function approximation. IEEE
Transactions on Information Theory, 39(3):999–1013, 1993.

## Feedback
Email your feedback to <a href="mailto:abhi.achoudhary@gmail.com">Abhishek Choudhary</a>.
