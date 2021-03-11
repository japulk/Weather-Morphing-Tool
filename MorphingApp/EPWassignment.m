function [varargout] = EPWassignment(tmy, varargin)
%% Function to assign the variables to their correct places in .epw file and catch the errors

%% Input

MorphedYear     = varargin{1};
Temperature     = varargin{2};
SolarRadiation  = varargin{3};
WindSpeed       = varargin{4};

%% Pre-assignment 

YearLoc         = 1;
TempLoc         = 7; 
RadLoc          = 14;
WindLoc         = 22;

MaxRow          = size(tmy,1) + 8; % From EPWreader

%% Assignments

% Morphing Year

try
    
    tmy(9:MaxRow+8,YearLoc) = cellstr(string(MorphedYear));
    
catch
    
    errordlg('Please check Morphed Year variable is integer.')
    
end

% Temperature

try
                            
    tmy(9:MaxRow+8,TempLoc) = cellstr(string(Temperature));
                                
catch 
                                
    errordlg('Original and morphed temperature files are different in size. Please check and ensure the uniformity of the file sizes.', 'Temperature file saving error')
                                
end

% Solar Radiation

try 
                                
    tmy(9:MaxRow+8,RadLoc) = cellstr(string(SolarRadiation));
                                
catch
                                
    errordlg('Original and morphed Radiation files are different in size. Please check and ensure the uniformity of the file sizes.', 'Solar Radiation file saving error')
                            
end

% Wind Speed 

try 
                                
    tmy(9:MaxRow+8,WindLoc) = cellstr(string(WindSpeed));
                                
catch
                                
    errordlg('Original and morphed Wind Speed file sre different in size. Please check and ensure the uniformity of the file sizes.', 'Wind Speed file saving error')
                                
end


%% Output
% If no errors occur carry these files back

varargout{1} = tmy;

end

