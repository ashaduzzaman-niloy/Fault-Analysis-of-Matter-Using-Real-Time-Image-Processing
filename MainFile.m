close all; clear all;
%% Access image acquisition device
vidobj=ipcam('http://192.168.43.1:8080/video');
%start(vidobj);

%% Preview image to position camera
preview(vidobj);

%% Capture the image
rgb=snapshot(vidobj);
figure, imshow(rgb);

%% Segment all objects
I=rgb2gray(rgb);
background=imclose(I,strel('disk',250));
I2=imsubtract(background,I);
% BW=imbinarize(I2);
BW=im2bw(I2,graythresh(I2));
BW=bwareaopen(BW, 20);
BW=imclearborder(BW);
fill=imfill(BW,'holes');
figure, imshow(fill);

%% Post process results if necessary
level=thresh_tool(I2);
BW=im2bw(I2,level/255);
BW=bwareaopen(BW,20);
BW=imclearborder(BW);
fill=imfill(BW,'holes');
figure, imshow(fill);

%% Use feature analysis to identify broken objects
[statsDefects,stats]=getStatsOnDefects(BW);

%% Label broken objects
figure; imshow(rgb);
hold on;
for idx=1:length(statsDefects)
    h=rectangle('Position', statsDefects(idx).BoundingBox, ...
        'LineWidth', 2);
    set(h,'EdgeColor',[0.75 0 0]);
    hold on;
end
qew=sprintf('Faulty Objects: %d',idx);
msgbox(qew)
hold off;

%%Clean Up
% delete(vidobj);
% clear vidobj;
% clear all;
% close all;