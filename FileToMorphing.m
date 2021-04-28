function [DataBase] = FileToMorphing(InputData)
%% This file is used to initiate the morphing and calculate the values it requires
% The function calculates the input data from files for the use for
% morphing. It also calls the morphing file, saves the morphed file and
% eventually helps in its usage on smart/thermal house model.
%% Input Data
% This part is used to process input data.
StartDate       = datetime(InputData.Time.StartDate.Year, InputData.Time.StartDate.Month, InputData.Time.StartDate.Day, 0, 0, 0);     % This is used to save the start date of the current weather file
EndDate         = datetime(InputData.Time.EndDate.Year, InputData.Time.EndDate.Month, InputData.Time.EndDate.Day, -1, 0, 0);       % This is used to save the end date of the current weather file
Scenario        = InputData.Scenario;           % This is the name of the selected scenario
Place           = InputData.Place;              % This is the coordinates of the place
Spacial_Error   = InputData.Spacial_Error;      % This is the spacial error  for describing and determining the area to look in the future scenario files
% File names for reading
FileName_monthly= InputData.FileName.FileName_monthly;  % This saves the file name for the monthly future scenario file
FileName_tas    = InputData.FileName.FileName_tas;  % This saves the file name for the average air temperature file for climate change
% FileName_tasmin = InputData.FileName.FileName_tasmin; % This is the file name for the daily minimum temperature for future scenarios
% FileName_tasmax = InputData.FileName.FileName_tasmax; % This is the file name for the daily msximum temperature for future scenarios
FileForSolar    = InputData.FileName.FileForSolar;      % This is the file for solar radiation
FileForWind     = InputData.FileName.FileForWind;       % This is the file for wind speed
% Location        = InputData.FileName.Location;      % This is the name of the location

UseOneBaseline  = InputData.FileName.UseOneFile;    

PathTemp        = InputData.FileName.PathTemp;      % This is the path were you want to save your file
PathRad         = InputData.FileName.PathRad;
PathWind        = InputData.FileName.PathWind;

FileNameTemp    = InputData.FileName.FileNameTemp;
FileNameRad     = InputData.FileName.FileNameRad;
FileNameWind    = InputData.FileName.FileNameWind;
SaveFormatTemp  = InputData.FileName.SaveFormatTemp;
SaveFormatRad   = InputData.FileName.SaveFormatRad;
SaveFormatWind  = InputData.FileName.SaveFormatWind;

SaveType        = InputData.FileName.SaveType;

DailyTech       = InputData.FileName.DailyTech;     % This describes the daily temperature database, either uses max and min values, or std of daily temperatures
DatabaseType    = InputData.FileName.DatabaseType;  % This the montly mean temperature file's database type
DataBaseTypeRadiationAndWind = InputData.FileName.DataBaseTypeRadiationAndWind;
% Additional information
AveragePeriod   = InputData.AveragePeriod;      % This is the period to which the daily results will be averaged
StartYearDaily  = InputData.StartYearDaily;     % This is the start year of the daily database 
ReferenceYear   = InputData.ReferenceYear;      % This is the reference year for daily delta variation calculation (usually the same as in start year daily)
StartYearMonthly = InputData.StartYearMonthly;   % This is the start year of the monthly data base
StartYearRad    = InputData.StartYearRad;       % This is the start year of future radiation data
MorphingYear    = InputData.MorphingYear;       % This is the year to which you want to eventually morph the data (Be sure to be consistent with your selections, so that morphing year will be part of the averaged periods!)
StartYearWind   = InputData.StartYearWind;      % Start year of the future wind change data

TimeVector      = StartDate:hours(1):EndDate;

ReferencePointMonthly   = ReferenceYear - StartYearMonthly + 1;
MorphingPointMonthly    = MorphingYear - StartYearMonthly + 1;
ReferencePointRad       = ReferenceYear - StartYearRad + 1;
ReferencePointWind      = ReferenceYear - StartYearWind + 1;
MorphingPointRad        = MorphingYear - StartYearRad + 1;
MorphingPointWind       = MorphingYear - StartYearWind + 1;

%% Read the used variables

% Determine the file parts for the temperature and radiation files
[~, ~, TempExt] = fileparts(InputData.FileName.Temperature);
[~, ~, RadExt]  = fileparts(InputData.FileName.SolarRadiation);
[~, ~, WinExt]  = fileparts(InputData.FileName.WindSpeed);

FileExtensions  = {TempExt, RadExt, WinExt};
VariableNames   = {'Temperature', 'Global_horisontal_radiation', 'WindSpeed'};
FileNames       = {'Temperature', 'SolarRadiation', 'WindSpeed'};

if UseOneBaseline == 1
    
    switch FileExtensions{1}
        
        case '.mat'
            
            Temperature     = load(InputData.FileName.(FileNames{1}), 'Temperature');
            Solar_Radiation = load(InputData.FileName.(FileNames{1}), 'Solar_Radiation');
            WindSpeed       = load(InputData.FileName.(FileNames{1}), 'WindSpeed');
            
            if isstruct(Temperature)
                Temperature = Temperature.Temperature;
            end
            
            if isstruct(Solar_Radiation)
                Solar_Radiation = Solar_Radiation.Solar_Radiation;
            end
            
            if isstruct(WindSpeed)
                WindSpeed = WindSpeed.WindSpeed;
            end
            
        otherwise
            
            [Temperature] = readClimateVariables(InputData.FileName.(FileNames{1}), 'Temperature');
            [Solar_Radiation] = readClimateVariables(InputData.FileName.(FileNames{1}), 'Global_horizontal_radiation');
            [WindSpeed]     = readClimateVariables(InputData.FileName.(FileNames{1}), 'WindSpeed');
            
    end
    
else            

for h = 1:3     % Loop through both options
    
    switch FileExtensions{h}
        
        case '.mat'
            
            if h == 1
                
                Temperature     = load(InputData.FileName.(FileNames{h}), 'Temperature');
                
                if isstruct(Temperature)
                    Temperature = Temperature.Temperature;
                end
                
            elseif h == 2
                
                Solar_Radiation = load(InputData.FileName.(FileNames{h}));
                
            else
                
                WindSpeed       = load(InputData.FileName.(FileNames{h}));
                
            end
            
        otherwise
            
            if h == 1
            
                [Temperature]       = readClimateVariables(InputData.FileName.(FileNames{h}), VariableNames{h});
                
            elseif h == 2
                
                [Solar_Radiation]   = readClimateVariables(InputData.FileName.(FileNames{h}), VariableNames{h});
                
            else
                
                [WindSpeed]         = readClimateVariables(InputData.FileName.(FileNames{h}), VariableNames{h});
                
            end
            
    end
    
end

end

%% Variables from current climate
% This part is used to calculate the variables from current climate for
% reference and determining the changes from them

[ClimateVariables] = CalculateClimateVariables(Temperature, Solar_Radiation, WindSpeed, StartDate, EndDate);

% Add the variables for future use here!
%% Monthly delta calculation
% Currently this only works for the nc-files from Paituli database (FMI's
% climate change scenario data

[~,~,FileType]     = fileparts(FileName_monthly);

switch FileType
    
    case '.nc'

        [tasOrg]             = deltaMonthly(FileName_monthly, Place, Spacial_Error);
        
        delta               = tasOrg(:,MorphingPointMonthly) - tasOrg(:,ReferencePointMonthly);
    
    otherwise
        
        [delta]             = ReadMonthlyChange(FileName_monthly, ClimateVariables.MonthlyMean, DatabaseType, ReferencePointMonthly, MorphingPointMonthly, AveragePeriod);
        
end

[~, ar]             = deltaMonthlyRad(FileForSolar, ReferencePointRad, MorphingPointRad, AveragePeriod, DataBaseTypeRadiationAndWind);

[~, aw]             = deltaMonthlyWind(FileForWind, ReferencePointWind, MorphingPointWind, AveragePeriod, DataBaseTypeRadiationAndWind);  

% Check the name of the variable for future use!

%% Daily changes calculation
% This section is used to calculate the daily changes in mean temperature,
% variance and on so on. The different options are depicted in them as
% well. Currently only nc-files are used in deltadaily and readable files
% for the daily temperature change from standard deviation.

if strcmp(DailyTech, 'MaxMin')

    switch (DatabaseType)
        
        case 'LongTermMean'
            
            [MorphedAlfa] = LongTermAlfa(FileName_tas, ClimateVariables.Dailystd);
            
            DataBase.(Scenario).morphedalfa = MorphedAlfa;
            
        otherwise
    
[~, mean_tasPlace, ~, mean_tasminPlace, ~, mean_tasmaxPlace] = deltaDaily(FileName_tas, InputData.FileName.FileName_tasmin, InputData.FileName.FileName_tasmax, Place, Spacial_Error);

% Add here the part for assigning the values to database structure

DataBase.(Scenario).mean.mean_tasPlace      = mean_tasPlace;
DataBase.(Scenario).min.mean_tasminPlace    = mean_tasminPlace;
DataBase.(Scenario).max.mean_tasmaxPlace    = mean_tasmaxPlace;

% Call the function to calculate the daily variation to an averages period

[DataBase] = ConvertDaylyToMonthly(DataBase, Scenario, StartYearDaily, ReferenceYear, AveragePeriod, MorphingYear);

    end

elseif strcmp(DailyTech, 'StdDaily')
    
    if ~iscell(FileName_tas)
    
        [~,~,DailyExt] = fileparts(FileName_tas);
        
    else
        
        DailyExt = '.csv';
        
    end
    
    switch DailyExt
        
        case '.nc'
            
            [mean_tas] = ReadDailyMeanNc(FileName_tas, Place, Spacial_Error);
            
            DataBase.(Scenario).mean.mean_tasPlace      = mean_tas;
            
            [DataBase] = alfaCalculator(DataBase, Scenario, StartYearDaily, ReferenceYear, AveragePeriod, MorphingYear);
            
        otherwise
            
            [DataBase] = stdDailyFunc(FileName_tas, Scenario, StartYearDaily, ReferenceYear, AveragePeriod, MorphingYear);
            
    end
    
elseif strcmp(DailyTech, 'Only monthly')
    
    if strcmp(InputData.MorphingTech, {'Shift and stretch', 'Stretch'})
    
        errordlg('Only monthly data cannot be used with Shift and stretch or Stretch morphing options. Please correct your selection.')
        
    else
        
        DataBase.(Scenario).morphedalfa = 0;
    
    end
    
        
end
% Add here the necessary changes of variable names

%% Selection of correct values for morphing
% This part is used to select the correct values from the previous
% variables for the morphing process

% Monthly value
SelectedYearMonthly     = MorphingPointMonthly - ReferencePointMonthly + 1; % MorphingYear - StartYearMonthly + 1;     % Select the suitable column number for the selection of climate change variable
SelectedYearRad         = MorphingPointRad - ReferencePointRad + 1; %MorphingYear - StartYearRad +1;           % Select the suitable column number for the radiation calculation

% From daily values
SelectedYearDaily       = ceil((MorphingYear - StartYearDaily)/AveragePeriod);    % Used to define the selected column from the averaged period values

%% Morphing
% This is the actual morphing part where the morphed hourly temperature and
% solar radiation files are created for the future

[FutureHourlyData] = Morphing(ClimateVariables, delta, DataBase.(Scenario).morphedalfa, InputData.MorphingTech, Temperature, Solar_Radiation, WindSpeed, TimeVector, ar, aw);

%% Output values from the function
% Just define the output values from the function. Consider whether to have
% a separate file to assing inputs and save the outputs to a folder!

% File names
% FileName        = Location+"_"+Scenario+"_"+string(MorphingYear)+"_"+DatabaseType;

Dir         = {PathTemp, PathRad, PathWind};
FileName    = {FileNameTemp, FileNameRad, FileNameWind};
SaveFormat  = {SaveFormatTemp, SaveFormatRad, SaveFormatWind};
Variables   = {'Temperature', 'Solar_Radiation', 'WindSpeed'};
EPWVaribles = {'Dry_Bulb_Temperature', 'Global_Horizontal_Radiation', 'Wind_Speed'};

% Re-assign Morphed varibales to their original names
Temperature     = FutureHourlyData.Temperature;
Solar_Radiation = FutureHourlyData.Radiation;
WindSpeed       = FutureHourlyData.Wind;


switch(SaveType)
    
    case 'Multiple'
        
        for m = 1:3

%         FileNameTemp    = Path + "Future Hourly Temperature Data "+Scenario+" "+Location+" "+string(MorphingYear)+"\Temperature_"+FileName+".mat";
%         FileNameRad     = Path + "Future Hourly Radiation Data "+Scenario+" "+Location+" "+string(MorphingYear)+"\Solar_Radiation_"+FileName+".mat";
%         FileNameWind    = Path + "Future Hourly Radiation Data "+Scenario+" "+Location+" "+string(MorphingYear)+"\WindSpeed_"+FileName+".mat";

%                 TempDir = PathTemp + FileNameTemp +SaveFormat;
%                 RadDir  = PathRad  + FileNameRad +SaveFormat;
%                 WindDir = PathWind + FileNameWind +SaveFormat;

            FullFile = string(Dir{m})+string(FileName{m})+string(SaveFormat{m});

        % Check if similar file already exists
        if ~isfile(FullFile)

            % Save file
            mkdir(FullFile)
            
        end
        
        switch(SaveFormat{m})
            
            case '.mat'
        
                save(FullFile, Variables{m})
            
            case '.csv'
                
                writematrix(Variables{m}, FullFile)
                
        end
        
        end
        
    case 'Single'
        
        FullFileName = string(Dir{1})+"\"+string(FileName{1})+string(SaveFormat{1});
        
                if ~isfolder(string(Dir{1}))
                    
                    mkdir(string(Dir{1}))
                    
                end
        
        switch(SaveFormat{1})
            
            case '.mat'
                
                save(FullFileName, Variables{1:3})
                
            case '.csv'
                
                if ~iscolumn(Temperature)
                    
                    Temperature = Temperature';
                    
                end
                
                if ~iscolumn(Solar_Radiation)
                    
                    Solar_Radiation = Solar_Radiation';
                    
                end
                
                if ~iscolumn(WindSpeed)
                    
                    WindSpeed = WindSpeed';
                    
                end
                
                Comb = table(Temperature, Solar_Radiation, WindSpeed);
                
                writetable(Comb, FullFileName)
                
        end
                
                
                
            
            
            
%             mkdir(Path,"Radiation"+Scenario+" "+Location+" "+string(MorphingYear))
%             mkdir(Path,"WindSpeed"+Scenario+" "+Location+" "+string(MoprhingYear))
%             save(FileNameTemp, '-struct', 'FutureHourlyData','Temperature')
%             save(FileNameRad, '-struct', 'FutureHourlyData','Radiation')
% 
%         elseif ~isfile(FileNameTemp)
%             save(FileNameTemp, '-struct', 'FutureHourlyData.Temperature')
%     
%         elseif ~isfile(FileNameRad)
%             save(FileNameRad, '-struct', 'FutureHourlyData.Radiation')
%     
%         else
%             save(FileNameTemp, '-struct', 'FutureHourlyData', 'Temperature')
%             save(FileNameRad, '-struct', 'FutureHourlyData', 'Radiation')
%             %uiwait('Both paths already exist')
%     
%         end
%         
%             case '.csv'
%         
%                 FileNameTemp    = Path + "Future Hourly Temperature Data "+Scenario+" "+Location+" "+string(MorphingYear)+"\Temperature_"+FileName+".mat";
%                 FileNameRad     = Path + "Future Hourly Radiation Data "+Scenario+" "+Location+" "+string(MorphingYear)+"\Solar_Radiation_"+FileName+".mat";        
        

        
end

end

