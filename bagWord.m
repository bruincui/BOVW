function bagWord( param )
% Generate bag-of-visual-word representation for each image

    savePath = strcat(param.globalPath, 'BOW.mat');
    if exist(savePath, 'file')
        fprintf('The visual dictionary exists!\n')
        return;
    end

    dictPath = strcat(param.globalPath, 'vDictionary.mat');
    load(dictPath);

    BOW = zeros(param.imgNum, param.nCenters);
    for i = 1 : param.imgNum
        if mod(i, 100) == 0
            fprintf('Representation for the %g-th image\n', i);
        end
        
        filePath = strcat(param.localPath, param.images{i}, '_RootSIFT.mat');
        load(filePath);
        
        [~, index] = min(euclideanDist(descr', dict'), [], 2);
        b = accumarray(index, 1, [param.nCenters 1]);
        BOW(i, :) = (b / sum(b))';
    end

    save(savePath, 'BOW');
end

function D = euclideanDist(X, Y)
% Calculate the squared euclidean distance between each point in X and each
% point in Y

    m = size(X,1); n = size(Y,1);
    
    XX = sum(X.*X,2);
    YY = sum(Y'.*Y',1);
    D = XX(:,ones(1,n)) + YY(ones(1,m),:) - 2*X*Y';
    
end

