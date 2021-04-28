function StartMorphingFromApp(app)
%% This is a function to execute the morphing App

dbstop if error

%% Input
% InputData are changed to be suitable for usage in moprhing files

InputData.Time.StartDate    = app.StartDateDatePicker.Value;     % This is used to save the start date of the current weather file
InputData.Time.EndDate      = app.EndDateDatePicker.Value;       % This is used to save the end date of the current weather file

ScenarioValues  = {'RCP2.6', 'RCP4.5', 'RCP6.0', 'RCP8.5'};
ScenarioNames   = {'RCP26', 'RCP45', 'RCP60', 'RCP85'};

SelectedScenario = strcmp(app.ClimatechangescenarioDropDown.Value, ScenarioValues);

InputData.Scenario          = ScenarioNames{SelectedScenario};           % This is the name of the selected scenario
InputData.Place             = [app.LatitudeEditField.Value, app.LongitudeEditField.Value];              % This is the coordinates of the place
InputData.Spacial_Error     = app.SpacialerrorEditField.Value;      % This is the spacial error  for describing and determining the area to look in the future scenario files
InputData.FileName.Location = app.LocationNameEditField.Value;      % This is the name of the location

% File names for reading
InputData.FileName.Temperature      = app.BaselineTemperaturefilelocationEditField.Value;
InputData.FileName.SolarRadiation   = app.BaselineGlobalRadiationFileEditField.Value;
InputData.FileName.WindSpeed        = app.BaselineWindSpeedFileEditField.Value;

InputData.FileName.UseOneFile       = app.UsethesamebaselinedataforallvariablesCheckBox.Value;

InputData.FileName.FileName_monthly = app.MonthlyChangeDataFileEditField.Value;  % This saves the file name for the monthly future scenario file
InputData.FileName.FileName_tas     = app.FutureDailyMeantemperatureDatafileEditField.Value;  % This saves the file name for the average air temperature file for climate change
InputData.FileName.FileName_tasmin  = app.FutureDailyMintemperatureDatafileEditField.Value; % This is the file name for the daily minimum temperature for future scenarios
InputData.FileName.FileName_tasmax  = app.FutureDailyMaxtemperatureDatafileEditField.Value; % This is the file name for the daily msximum temperature for future scenarios

InputData.FileName.FileForSolar     = app.MonthlyGlobalRadiationChangeEditField.Value;      % This is the file for solar radiation
InputData.FileName.FileForWind      = app.MonthlyWindSpeedChangeEditField.Value;       % This is the file for wind speed

InputData.FileName.PathTemp         = app.TemperaturefilepathEditField.Value;      % This is the path were you want to save your file
InputData.FileName.PathRad          = app.RadiationfilepathEditField.Value;
InputData.FileName.PathWind         = app.WindfilepathEditField.Value;

InputData.FileName.FileNameTemp     = app.TemperaturefilenameEditField.Value;
InputData.FileName.FileNameRad      = app.RadiationfilenameEditField.Value;
InputData.FileName.FileNameWind     = app.WindfilenameEditField.Value;

InputData.FileName.SaveFormatTemp   = app.TemperatureFileTypeDropDown.Value;
InputData.FileName.SaveFormatRad    = app.RadiationFileTypeDropDown.Value;
InputData.FileName.SaveFormatWind   = app.WindFileTypeDropDown.Value;

if app.Saveallvariableson1fileCheckBox.Value == 1

    InputData.FileName.SaveType     = 'Single';
    
else
    
    InputData.FileName.SaveTyoe     = 'Multiple';
    
end

if app.OnlymonthlyButton.Value == 1

    InputData.FileName.DailyTech    = 'Only monthly';   % This describes the daily temperature database, either uses max and min values, or std of daily temperatures

elseif app.StdDailyButton.Value == 1
    
    InputData.FileName.DailyTech    = 'StdDaily';
    
elseif app.MaxMinButton.Value == 1
    
    InputData.FileName.DailyTech    = 'MaxMin';
    
end

InputData.FileName.DatabaseType     = app.DataBaseTypeDropDown.Value;  % This the montly mean temperature file's database type

InputData.FileName.DataBaseTypeRadiationAndWind     = app.DataBaseTypeRadiationWindDropDown.Value;

if app.ShiftButton.Value == 1

    InputData.MorphingTech(1)       = {'Shift'};

elseif app.StretchButton.Value == 1
    
    InputData.MorphingTech(1)       = {'Stretch'};
    
else
    
    InputData.MorphingTech(1)       = {'Shift and Stretch'};
    
end

InputData.MorphingTech(2:3)         = {'Stretch'};

% Additional information
InputData.AveragePeriod             = app.AveragePeriodEditField.Value;      % This is the period to which the daily results will be averaged
InputData.StartYearDaily            = app.DailyTemperatureStartYearEditField.Value;     % This is the start year of the daily database 
InputData.ReferenceYear             = app.ReferenceYearEditField.Value;      % This is the reference year for daily delta variation calculation (usually the same as in start year daily)
InputData.StartYearMonthly          = app.MonthlyTemperatureStartYearEditField.Value;   % This is the start year of the monthly data base
InputData.StartYearRad              = app.RadiationChangeStartYearEditField.Value;       % This is the start year of future radiation data
InputData.MorphingYear              = app.MorphingYearEditField.Value;       % This is the year to which you want to eventually morph the data (Be sure to be consistent with your selections, so that morphing year will be part of the averaged periods!)
InputData.StartYearWind             = app.WindChangeStartYearEditField.Value;      % Start year of the future wind change data

%% Call the morphing

[~] = FileToMorphing(InputData);

%% Inform that the morhing has been carried out successfully

msgbox('Morphing completed.', 'Operation complete')

end

