%% This script can convert video into series of images
clc;clear;
obj = VideoReader('test.avi');
vid = read(obj);
frames = obj.NumberOfFrames;
for ii = 1 : frames
%     imwrite(vid(:,:,:,x),strcat('frame-',num2str(x),'.png'));
    imwrite(vid(:,:,:,ii),['output\',num2str(ii),'.tif']);
end