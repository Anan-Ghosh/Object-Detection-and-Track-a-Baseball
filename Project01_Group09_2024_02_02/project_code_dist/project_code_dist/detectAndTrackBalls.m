function [ballA, ballB] = detectAndTrackBalls(dclipA, dclipB)
    % Load ROI masks from MATLAB files
    roiMaskA = load("MaskRoi_A.mat");  % Adjust the filename as needed
    roiMaskB = load("MaskRoi_B.mat");  % Adjust the filename as needed

    % Access the mask variables from the loaded data
    maskA = roiMaskA.mask;  % Access the mask field in roiMaskA
    maskB = roiMaskB.mask;  % Access the mask field in roiMaskB

    % Define threshold value for masking
    threshold = 220;

    % Initialize arrays to store detected ball information
    ballA = struct('x', [], 'y', [], 'frame', [], 'image', []);
    ballB = struct('x', [], 'y', [], 'frame', [], 'image', []);

    % Loop through frames of camera A
    for frameIdx = 1:size(dclipA, 3)
        % Extract current frame from camera A
        frameA = dclipA(:, :, frameIdx);

        % Apply masking to detect ball coordinates using ROI mask for camera A
        maskedFrameA = frameA .* maskA;

        % Detect ball as objects within masked frame for camera A
        binaryFrameA = maskedFrameA > threshold;
        ccA = bwconncomp(binaryFrameA);
        statsA = regionprops(ccA, 'Centroid');

        % Extract centroid coordinates for each detected ball in camera A
        for ballIdx = 1:length(statsA)
            ballA(end + 1).x = statsA(ballIdx).Centroid(1);
            ballA(end).y = statsA(ballIdx).Centroid(2);
            ballA(end).frame = frameIdx;
            ballA(end).image = 1; % Image number in frame A

        end
    end

    % Loop through frames of camera B
    for frameIdx = 1:size(dclipB, 3)
        % Extract current frame from camera B
        frameB = dclipB(:, :, frameIdx);

        % Apply masking to detect ball coordinates using ROI mask for camera B
        maskedFrameB = frameB .* maskB;

        % Detect ball as objects within masked frame for camera B
        binaryFrameB = maskedFrameB > threshold;
        ccB = bwconncomp(binaryFrameB);
        statsB = regionprops(ccB, 'Centroid');

        % Extract centroid coordinates for each detected ball in camera B
        for ballIdx = 1:length(statsB)
            ballB(end + 1).x = statsB(ballIdx).Centroid(1);
            ballB(end).y = statsB(ballIdx).Centroid(2);
            ballB(end).frame = frameIdx;
            ballB(end).image = 2; % Image number in frame B
        end
    end

    % Initialize an array to store the count of detected balls in each frame
    ballCountA = zeros(1, size(dclipA, 3)); % For camera A
    ballCountB = zeros(1, size(dclipB, 3)); % For camera B

    % Loop through frames of camera A
    for frameIdx = 1:size(dclipA, 3)
        % Count the number of detected balls in the current frame
        ballCountA(frameIdx) = length(ballA([ballA.frame] == frameIdx));
    end

    % Loop through frames of camera B
    for frameIdx = 1:size(dclipB, 3)
        % Count the number of detected balls in the current frame
        ballCountB(frameIdx) = length(ballB([ballB.frame] == frameIdx));
    end

    % Display the count of detected balls in each frame for camera A
    disp("Detected balls count in each frame for camera A: 21 Frames");

        disp(ballCountA);

    % Display the count of detected balls in each frame for camera B
    disp("Detected balls count in each frame for camera B: 21 Frames");
    disp(ballCountB);
end









