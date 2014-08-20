function rootSift( param )
% Generate root sift descriptors for each image using Andrea Vedaldi's codes
%
% Reference
% [1] http://www.robots.ox.ac.uk/~vedaldi/code/sift.html
% [2] Three things everyone should know to improve object retrieval

h = waitbar(0, 'Compute RootSIFT ...');
for i = 1 : param.imgNum

    savePath = strcat(param.localPath, param.images{i}, '_RootSIFT.mat');
    if exist(savePath, 'file')
        waitbar(i / param.imgNum, h);
        fprintf('RootSIFT descriptors for the %g-th image ...\n', i);
    else
        imgPath = strcat(param.imgDir, param.images{i}, '.jpg');
        im = imread(imgPath);
    
        % Convert to the grayscale image
        if ndims(im) == 3
            im = rgb2gray(im);
        end
    
        % The image must be gray-scale, of storage class DOUBLE and ranging
        % in [0,1].
        im = double(im);
        im = im - min(im(:));
        im = im / max(im(:));
    
        [~, descr] = sift(im, 'Verbosity', 0 );
        
        descr = rootS(descr);
        
        save(savePath, 'descr');
    
        waitbar(i / param.imgNum, h);
        fprintf('RootSIFT descriptors for the %g-th image ...\n', i);   
    end
end

close(h);

end

function R = rootS(D)
    
    % L-1 normalize
    z = sum(D, 1);
    s = z + (z == 0);
    D = D ./ repmat(s, size(D, 1), 1);
    
    % square root each element
    R = sqrt(D);
end

