function [FWind, aw] = deltaMonthlyWind(FileForWind, ReferencePointWind, MorphingPoint, AveragePeriod, DataBaseTypeRadiationAndWind)
%% This function is used to calculate the relative change in solar radiation due to climate change
% Define the current average value and future change to here, currently on
% monthly basis

Values       = readtable(FileForWind);
VariableName = 'WindSpeed';
ChangeInWind = Values.(VariableName);

%% Loop through the months to discover the relative change in solar radiation

switch(DataBaseTypeRadiationAndWind)
    
    case 'LongTermMean'
        
        aw = zeros(1,12);
        FWind = zeros(1,12);
        
        for h = 1:12    % Loop through all 12 months
            
%             aw(h) = 1 + ((ChangeInWind(h+12)/ChangeInWind(h))/100);    % Here the file is assumed to include the baseline weather, plus only the new long-term mean values

            aw(h) = 1 + ((ChangeInWind(h+12)-ChangeInWind(h))/(ChangeInWind(h)));
            FWind(h) = ChangeInWind(h+12);

        end
        
    case 'Relative Change'
        
        aw = 1 + ChangeInWind/100;                                              % Here the change in wind is assumed to only include relative change values in percentages
         
    case 'Monthly'

% a       = zeros(12,length(ChangeInRad)/12);
FWind 	= zeros(12,length(ChangeInWind)/12);

for i = 1:12
    SelectedMonth = i;  % Assign selected month
    idx = 1;            % Index value for allocating
    for j = SelectedMonth:12:length(ChangeInWind) % Loop every month for the lenght of the database
        FWind(SelectedMonth,idx) = ChangeInWind(j);   % This organises the average values to a useble and comparable form
        idx = idx + 1;
    end
end

if ReferencePointWind - AveragePeriod/2 <= 0
    ReferencePointWind = (AveragePeriod/2) + 1;
end

aw = 1 + (mean(FWind(:,MorphingPoint-(AveragePeriod/2):MorphingPoint+(AveragePeriod/2)),2) - mean(FWind(:,ReferencePointWind-(AveragePeriod/2):ReferencePointWind+(AveragePeriod/2)),2))/100;

% a = ChangeInRad./ChangeInRad(ReferencePointRad);  % Compare to the first year!

end

end

