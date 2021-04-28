function [MorphedAlfa] = LongTermAlfa(File_tas, stdCurrent)
% Function used to calculate morphed alfa in case of long term max min
% changes
%% Inputs
DailyStdChange      = readtable(File_tas);
stdRelativeChange   = DailyStdChange.std';
%% Calculate morphed alfa
   MorphedAlfa = (stdRelativeChange(13:24)./stdRelativeChange(1:12)) - 1; 
%% Outputs
end

