function varargout = manit1(varargin)
% MANIT1 M-file for manit1.fig
%      MANIT1, by itself, creates a new MANIT1 or raises the existing
%      singleton*.
%
%      H = MANIT1 returns the handle to a new MANIT1 or the handle to
%      the existing singleton*.
%
%      MANIT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANIT1.M with the given input arguments.
%
%      MANIT1('Property','Value',...) creates a new MANIT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manit1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manit1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manit1

% Last Modified by GUIDE v2.5 14-Jun-2015 10:32:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manit1_OpeningFcn, ...
                   'gui_OutputFcn',  @manit1_OutputFcn, ...
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


% --- Executes just before manit1 is made visible.
function manit1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manit1 (see VARARGIN)

% Choose default command line output for manit1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manit1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manit1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browsecoverimg.
function browsecoverimg_Callback(hObject, eventdata, handles)
% hObject    handle to browsecoverimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.*'}, 'Pick an Image File');
S = imread([pathname,filename]);
S=imresize(S,[512,512]);
axes(handles.axes1)
imshow(S)
title('Cover Image')
set(handles.text3,'string',filename)
handles.S=S;
guidata(hObject,handles)

% --- Executes on button press in browsemsg.
function browsemsg_Callback(hObject, eventdata, handles)
% hObject    handle to browsemsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
msg = imread([pathname,filename]);
axes(handles.axes2)
imshow(msg)
title('Input Message')
set(handles.text4,'string',filename)
handles.msg=msg;
guidata(hObject,handles)

% --- Executes on button press in DWT.
function DWT_Callback(hObject, eventdata, handles)
% hObject    handle to DWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message=handles.msg;
cover_object=handles.S;
k=10;
[watermrkd_img,PSNR,IF,NCC,recmessage]=dwt(cover_object,message,k);
axes(handles.axes3)
imshow(watermrkd_img)
title('Watermarked Image')
axes(handles.axes4)
imshow(recmessage)
title('Recovered Message')
a=[PSNR,NCC,IF]';
t=handles.uitable1;
set(t,'Data',a)
handles.a=a;
guidata(hObject,handles)

% --- Executes on button press in DWTDCT.
function DWTDCT_Callback(hObject, eventdata, handles)
% hObject    handle to DWTDCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
message=handles.msg;
cover_object=handles.S;
k=10;
[watermrkd_img,recmessage,PSNR,IF,NCC1] = dwtdct(cover_object,message,k);
axes(handles.axes3)
imshow(watermrkd_img)
title('DWT+DCT Watermarked Image')
axes(handles.axes4)
imshow(recmessage)
title('DWT+DCT Recovered Message')
b=[PSNR,NCC1,IF]';
t=handles.uitable1;
set(t,'Data',[a b])
handles.b=b;
guidata(hObject,handles)

% --- Executes on button press in DWTDCTBFO.
function DWTDCTBFO_Callback(hObject, eventdata, handles)
% hObject    handle to DWTDCTBFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
b=handles.b;
message=handles.msg;
cover_object=handles.S;
[watermrkd_img,recmessage,PSNR,IF,NCC,pbest] = BG(cover_object,message);
axes(handles.axes3)
imshow(watermrkd_img)
title('DWT+DCT+BFO Watermarked Image')
axes(handles.axes4)
imshow(recmessage)
title('DWT+DCT+BFO Recovered Message')
c=[PSNR,NCC,IF]';
t=handles.uitable1;
set(t,'Data',[a b c])
handles.c=c;
guidata(hObject,handles)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
b=handles.b;
c=handles.c;
d=handles.d;
PSNR=[a(1),b(1),c(1),d(1) ];
NCC=[a(2),b(2),c(2),d(2)];
IF=[a(3),b(3),c(3),d(3)];
figure
bar(PSNR)
set(gca,'XTickLabel',' ');
ylabel('PSNR')
text(1,0,'DWT','Rotation',260,'Fontsize',8);
text(2,0,'DWT+DCT','Rotation',260,'Fontsize',8);
text(3,0,'DWT+DCT+BFO','Rotation',260,'Fontsize',8);
text(4,0,'DWT+DCT+PBFO','Rotation',260,'Fontsize',8);
[t]=get(gca,'position');
set(gca,'position',[t(1) 0.31 t(3) 0.65])
title('Bar Graph Comparison of PSNR')
%%%%
figure
bar(NCC)
set(gca,'XTickLabel',' ');
ylabel('NCC')
text(1,0,'DWT','Rotation',260,'Fontsize',8);
text(2,0,'DWT+DCT','Rotation',260,'Fontsize',8);
text(3,0,'DWT+DCT+BFO','Rotation',260,'Fontsize',8);
text(4,0,'DWT+DCT+PBFO','Rotation',260,'Fontsize',8);
[t]=get(gca,'position');
set(gca,'position',[t(1) 0.31 t(3) 0.65])
title('Bar Graph Comparison of NCC')

% --- Executes on button press in DWTDCTPBFO.
function DWTDCTPBFO_Callback(hObject, eventdata, handles)
% hObject    handle to DWTDCTPBFO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
b=handles.b;
c=handles.c;
message=handles.msg;
cover_object=handles.S;
[watermrkd_img,recmessage,PSNR,IF,NCC,pbest] =BG_PSO(cover_object,message);
axes(handles.axes3)
imshow(watermrkd_img)
title('DWT+DCT+PBFO Watermarked Image')
axes(handles.axes4)
imshow(recmessage)
title('DWT+DCT+PBFO Recovered Message')
d=[PSNR,NCC,IF]';
t=handles.uitable1;
set(t,'Data',[a b c d])
handles.d=d;
guidata(hObject,handles)