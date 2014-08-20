
clear;
clc;

imageDir = './images/';

% the dimension of bow representation
param.nCenters = 500;

param.imgDir = imageDir;
param.localPath = './data/local/';
param.globalPath = './data/global/';

% load images
files = dir(strcat(param.imgDir, '*.jpg'));
param.imgNum = length(files);
param.images = cell(param.imgNum, 1);
for i = 1 : param.imgNum
    [~, param.images{i}, ~] = fileparts(files(i).name);
end

% Generate RootSIFT descriptors for each image using Andrea Vedaldi's codes
addpath('./sift');
rootSift(param);
fprintf('\n')

% Create the visual dictionary using kmeans algorithm
% Sample a certain number of images for generating the visual dictionary
param.nSampled = 1000;
visualDictionary(param);
fprintf('\n')

% Generate bow representation for each image
bagWord(param);


