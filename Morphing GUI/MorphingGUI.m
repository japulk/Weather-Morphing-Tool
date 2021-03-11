function varargout = MorphingGUI(varargin)
% MORPHINGGUI MATLAB code for MorphingGUI.fig
%      MORPHINGGUI, by itself, creates a new MORPHINGGUI or raises the existing
%      singleton*.
%
%      H = MORPHINGGUI returns the handle to a new MORPHINGGUI or the handle to
%      the existing singleton*.
%
%      MORPHINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MORPHINGGUI.M with the given input arguments.
%
%      MORPHINGGUI('Property','Value',...) creates a new MORPHINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MorphingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MorphingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MorphingGUI

% Last Modified by GUIDE v2.5 09-Dec-2020 15:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MorphingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MorphingGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MorphingGUI is made visible.
function MorphingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MorphingGUI (see VARARGIN)

% Choose default command line output for MorphingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MorphingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MorphingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
