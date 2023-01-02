function [statsDefects,stats]=getStatsOnDefects(BW)

%%Use feature analysis to identify broken objects
[labeled, numObjects]=bwlabel(BW,8);
stats=regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas=[stats.Area];
minSize=mean(areas)-0.05*std(areas);
eccentricities=[stats.Eccentricity];
idxOfDefects=find(areas<minSize & eccentricities>0.05);
statsDefects=stats(idxOfDefects);