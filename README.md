# SSDC
[Semi-supervised DenPeak Clustering with Pairwise Constraints](https://link.springer.com/chapter/10.1007/978-3-319-97304-3_64)

## Requirements
Matlab

## Running
```
[cl] = SSDC(X,percent, ML, CL, D)
```

### Parameters
**X:** --features, could use `load(data);X = zscore(fea);` to build features.  
**percent:** --an integer between 0 and 100, sort distances between data points with any other points in an ascending order and select the value in this percent to determined <a href="https://www.codecogs.com/eqnedit.php?latex=$d_{c}$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?$d_{c}$" title="$d_{c}$" /></a>.We use 3% in our experiments as default.  
**ML:** --Must-Link constraints.  
**CL:** --Cannot-Link constraints.  
**D:** --the proposed SSDC with <a href="https://www.codecogs.com/eqnedit.php?latex=\frac{\sqrt{n}}{D}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\frac{\sqrt{n}}{D}" title="\frac{\sqrt{n}}{D}" /></a> initial temporary clusters, if D is 1, initial <a href="https://www.codecogs.com/eqnedit.php?latex=\sqrt{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sqrt{n}" title="\sqrt{n}" /></a> temporary clusters. if D is 2, initial <a href="https://www.codecogs.com/eqnedit.php?latex=\frac{\sqrt{n}}{2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\frac{\sqrt{n}}{2}" title="\frac{\sqrt{n}}{2}" /></a> temporary clusters.  

### Result
**cl:** --clustering results.

### Construct constraints
```
[CL, ML] = MakeCons(gnd, N)
```

**gnd:** --data labels loaded from dataset.  
**N:** --an integer between 0 and 10, construct `(N% * number of data points)` pairwise constraints.

### Sample
You can run `one_sample.m` as `one_sample('Chainlink')` to learn how to use this code.


