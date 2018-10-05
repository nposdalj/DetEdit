%% Density_ClickCount

clearvars
close all

%% Parameters defined by user
filePrefix = {'DT','GC','MC'}; % File name to match. 
% File prefix should include site. 
sp = 'Pm'; % your species code
itnum = '2'; % which iteration you are looking for
tpwsPath = 'H:\newTPWS'; %directory of TPWS files
binsize = 5; % minutes per bin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% define subfolder that fit specified iteration
if itnum > 1
   for id = 2: str2num(itnum) % iternate id times according to itnum
       subfolder = ['TPWS',num2str(id)];
       tpwsPath = (fullfile(tpwsPath,subfolder));
   end
end

outDir = fullfile(tpwsPath,'Densities');
if ~isdir(outDir)
    disp(['Make new folder: ',outDir])
    mkdir(outDir)
end

for isite = 1:length(filePrefix)
%% Load Settings preferences
% Get parameter settings worked out between user preferences, defaults, and
% species-specific settings:
p = sp_setting_defaults('sp',sp,'site',filePrefix{isite});

FileParams = [site,'_',filePrefix{isite},'_summaryData_forDensity.mat'];
load(fullfile(tpwsPath,FileParams))

% convert count of clicks to clicks per 5min bin
clickPerBin = weekTable.Count_Click/(60*binsize);
clickMethodDensity = 1000*((clickPerBin.*(1-p.fpRate))./...
        (pi*p.modelRadius_km^2*p.pDet*(weekTable.Effort_Bin)*p.clickRate));
    
figure
plot(weekTable.tbin,clickMethodDensity,'o')
ylabel('Density (animals/1000 km^2)')


myData = [datenum(weekTable.tbin), clickMethodDensity];
outputFileName = [filePrefix{isite},'_',sp];
Deseason_data(myData,outDir,outputFileName)

end
