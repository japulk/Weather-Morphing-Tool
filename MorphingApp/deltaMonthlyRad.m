function [FRad, ar] = deltaMonthlyRad(FileForRad, ReferencePointRad, MorphingPoint, AveragePeriod, DataBaseTypeRadiationAndWind)
%% This function is used to calculate the relative change in solar radiation due to climate change
% Define the current average value and future change to here, currently on
% monthly basis

Values       = readtable(FileForRad);
VariableName = 'Global_horizontal_radiation';
ChangeInRad = Values.(VariableName);

%% Select the used calculation method for alfa by the user-selection

switch(DataBaseTypeRadiationAndWind)
    
    case 'LongTermMean'
        
        ar = zeros(1,12);
        
        for h = 1:12    % Loop through all 12 months
            
            ar(h) = 1 + ((ChangeInRad(h)-ChangeInRad(h+12))/ChangeInRad(h));    % Here the file is assumed to include the baseline weather, plus only the new long-term mean values
            
        end
        
    case 'Relative Change'
        
        ar = 1 + ChangeInRad/100;       % Here the change in rad file is assumed to inlcude only values for relative change in percentages
        
    case 'Monthly'

%% Loop through the months to discover the relative change in solar radiation

% a       = zeros(12,length(ChangeInRad)/12);
FRad 	= zeros(12,length(ChangeInRad)/12);

for i = 1:12
    SelectedMonth = i;  % Assign selected month
    idx = 1;            % Index value for allocating
    for j = SelectedMonth:12:length(ChangeInRad) % Loop every month for the lenght of the database
        FRad(SelectedMonth,idx) = ChangeInRad(j);   % This organises the average values to a useble and comparable form
        idx = idx + 1;
    end
end

if ReferencePointRad - AveragePeriod/2 <= 0
    ReferencePointRad = (AveragePeriod/2) + 1;
end

ar = 1 + (mean(FRad(:,MorphingPoint-(AveragePeriod/2):MorphingPoint+(AveragePeriod/2)),2)-mean(FRad(:,ReferencePointRad-(AveragePeriod/2):ReferencePointRad+(AveragePeriod/2)),2))./mean(FRad(:,ReferencePointRad-(AveragePeriod/2):ReferencePointRad+(AveragePeriod/2)),2);

end

% a = ChangeInRad./ChangeInRad(ReferencePointRad);  % Compare to the first year!

end

