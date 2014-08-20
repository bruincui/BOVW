function visualDictionary( param )
% Generate the visual dictionary
% We implement our own kmeans algorithm for saving memory

    savePath = strcat(param.globalPath, 'vDictionary.mat');
    if exist(savePath, 'file')
        fprintf('The visual dictionary exists!\n')
        return;
    end

    nCenters = param.nCenters;

    % Sample a certain number of images for generating the visual dictionary
    nSampled = param.nSampled;
    if param.imgNum < nSampled
        nSampled = param.imgNum;
    end
    fprintf('Sample %g images for generating the visual dictionary\n', nSampled)
    
    perm = randperm(param.imgNum);
    images = param.images(perm(1 : nSampled));

    % The number of descriptors per image
    nDescriptors = zeros(nSampled, 1);
    for i = 1 : nSampled
        filePath = strcat(param.localPath, images{i}, '_RootSIFT.mat');
        load(filePath);
    
        nDescriptors(i) = size(descr, 2);
    end
    dim = size(descr, 1);

    % Cumulative sum of the number of descriptors per image
    cumDescriptors = cumsum(nDescriptors);

    % The total number of descriptors we need to cluster
    nPoints = cumDescriptors(end);
    
    % Initialization
    display('Randomly choose initialized sift descriptor points')
    centers = zeros(nCenters, dim);
    perm = randperm(nPoints);
    perm = perm(1 : nCenters);
    for i = 1 : nCenters
        centers(i, :) = extractPoint(param.localPath, images, ...
                                    cumDescriptors, perm(i))';
    end
    
    
    % Configuration of kmeans
    maxIter = 100;
    errThr = 1E-2;
    flag = 0;
    
    display('Run k-means...')
    for i = 1 : maxIter
        
        fprintf('The %d-th iteration ...\n', i);
        
        tic
        
        old_centers = centers;
        tempc = zeros(nCenters, dim);
        npc = zeros(nCenters, 1);
        
        for j = 1 : nSampled
            filePath = strcat(param.localPath, images{j}, '_RootSIFT.mat');
            load(filePath);
            
            % Assign each point to the nearest center
            tempd = descr';
            [~, index] = min(euclideanDist(tempd, centers), [], 2);
            
            npc = npc + accumarray(index, 1, [nCenters 1]);
            
            for k = 1 : dim
                tempc(:, k) = tempc(:, k) + accumarray(index, tempd(:, k), ...
                                                       [nCenters 1]);
            end
            
        end
        
        for j = 1 : nCenters
            if  npc(j) > 0
                centers(j, :) = tempc(j, :) / npc(j);
            else
                centers(j, :) = 0;
            end
        end
        
        
        % Test for termination
        maxError = abs(max(max(centers - old_centers)));
        if  maxError < errThr
            fprintf('The max error in current iteration is %g\n', maxError);
            display('Save visual dictionary ...')
            dict = centers';
            flag = 1;
            break;
        else
            fprintf('The max error in current iteration is %g\n', maxError);
        end
        
        toc
        
        fprintf('\n')
        
    end
    
    if ~flag
        display('Run out of the maxmium number of iterations !')
        display('Save visual dictionary ...')
        dict = centers';
    end
    
    save(savePath, 'dict');
   
end


function p = extractPoint(path, images, cumNum, ind)
% Extract a descriptor point according to its index
    
    imgInd = find(cumNum >= ind, 1);
    if imgInd == 1
        descrInd = ind;
    else
        descrInd = ind - cumNum(imgInd - 1);
    end
    
    filePath = strcat(path, images{imgInd}, '_RootSIFT.mat');
    load(filePath);
    
    p = descr(:, descrInd);
end

function D = euclideanDist(X, Y)
% Calculate the squared euclidean distance between each point in X and each
% point in Y

    m = size(X,1); n = size(Y,1);
    
    XX = sum(X.*X,2);
    YY = sum(Y'.*Y',1);
    D = XX(:,ones(1,n)) + YY(ones(1,m),:) - 2*X*Y';
    
end

