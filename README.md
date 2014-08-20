BOVW
====

A MATALB script for extracting Bag-Of-Visual-Word features.

We generate root sift descriptors [1] for each image using Andrea Vedaldi's codes [2], and implement our own kmeans algorithm for saving memory.

Just put all images into the ./images/ directory, and then run main.m.The resulting BOVW features and word dictionary are saved in ./data/global/, and the root sift descriptor for each image is in ./data/local/.

References:  
[1] Three things everyone should know to improve object retrieval  
[2] http://www.robots.ox.ac.uk/~vedaldi/code/sift.html

Created by Chaoran Cui (bruincui@gmail.com)  
homepage: http://ir.sdu.edu.cn/~chaorancui/  
If there are any problems, please let me know.


