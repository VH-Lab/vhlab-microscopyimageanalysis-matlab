function varargout = ATGUI(varargin)
% ATGUI MATLAB code for ATGUI.fig
%      mia.GUI.archived_code.ATGUI, by itself, creates a new ATGUI or raises the existing
%      singleton*.
%
%      H = ATGUI returns the handle to a new ATGUI or the handle to
%      the existing singleton*.
%
%      mia.GUI.archived_code.ATGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in mia.GUI.archived_code.ATGUI.M with the given input arguments.
%
%      mia.GUI.archived_code.ATGUI('Property','Value',...) creates a new ATGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the mia.GUI.archived_code.ATGUIUI.archived_code.ATGUI before ATGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ATGUI_OpeningFcn via varargin.
%
%      *See mia.GUI.archived_code.ATGUI Options on GUIDE's Tools menu.  Choose "ATGUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mia.GUI.archived_code.ATGUI

% Last Modified by GUIDE v2.5 23-Jul-2014 14:21:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ATGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ATGUI_OutputFcn, ...
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


% --- Executes just before mia.GUI.archived_code.ATGUI is made visible.
function ATGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mia.GUI.archived_code.ATGUI (see VARARGIN)

% Choose default command line output for mia.GUI.archived_code.ATGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mia.GUI.archived_code.ATGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ATGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Call file-optionally select multiple files at once.
[filename handles.mydata.pathname] =...
    uigetfile({'*.tif'}, 'File Selector', 'MultiSelect', 'on');
tic;
[file_columns,file_rows]=size(filename);


if iscell(filename)
    for i= 1:file_rows
        handles.mydata.filename(i,:)=filename{i};
    end
else
    i=1;
    handles.mydata.filename(i,:)=filename;
end

[pathname,name,ext] = fileparts(handles.mydata.filename(1,:));
handles.mydata.pathsave=strcat(handles.mydata.pathname,name);
mkdir(handles.mydata.pathsave);

handles.mydata.frame=1;

%display image name
handles.mydata.select_image=1;
set(handles.text3,'String', handles.mydata.filename(handles.mydata.select_image,:));

%store mydata in gui handle
guidata(hObject,handles);
showimage(hObject,eventdata,handles);
toc

function showimage(hObject, eventdata, handles)
%get mydata from gui handle

handles.mydata.select_image = get(handles.popupmenu4, 'value');
handles.mydata.fileinfo = imfinfo(fullfile(handles.mydata.pathname,...
    handles.mydata.filename(handles.mydata.select_image,:)));
handles.mydata.imagefile = strcat(handles.mydata.pathname,...
    handles.mydata.filename(handles.mydata.select_image,:));
set(handles.text3,'String', handles.mydata.filename(handles.mydata.select_image,:));
colormap(gray(256));
im = imread(handles.mydata.imagefile, handles.mydata.frame);
set(handles.text7,'String', handles.mydata.frame);
set(handles.text9,'String', length(handles.mydata.fileinfo));
set(handles.slider2,'min',1,'max',length(handles.mydata.fileinfo),'value',...
    handles.mydata.frame,'sliderstep',[1 1]/(length(handles.mydata.fileinfo)-1));
  
axes(handles.axes4)
above_thresh = get(handles.checkbox1, 'Value');
if above_thresh
    thresh = str2num(get(handles.edit1,'string'));
    below_thresh = find(im <= thresh);
    im(below_thresh) = 0;
end;

mn = min(im(:));
mx = max(im(:));
imagefile_rescaled = rescale(double(im), double([mn mx]),[0 255]);
image(imagefile_rescaled(:,:,1));
axis equal;
guidata(hObject,handles);

axes(handles.axes2);
IMdata = readfullimage(hObject, eventdata, handles);
hist(double(IMdata(:)));

function IMdata = readfullimage(hObject,eventdata, handles)
IMdata = [];
for myframe = 1:length(handles.mydata.fileinfo)
    IMdata = cat(3,IMdata,imread(handles.mydata.imagefile,myframe));
end;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes(handles.axes4);
handles.mydata.frame = get(handles.slider2,'value');
guidata(hObject,handles)
showimage(hObject,eventdata,handles);
zoom reset

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
showimage(hObject,eventdata,handles);
% thresh = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Create Binary Image
thresh = str2num(get(handles.edit1,'string'));
size_thresh = str2num(get(handles.edit27,'string'));
IMdata = readfullimage(hObject, eventdata, handles);
imthresh = IMdata > thresh;


[pathname,name,ext] = fileparts(handles.mydata.filename(handles.mydata.select_image,:));
fullfilename=strcat(handles.mydata.pathsave, '\', name, '.mat');

%Home grown punta detection script.
[roi.imrois, roi.L, imrois2d,BW]...
    = mia.z_old_archived_code.spotdetector3(imthresh, 4, 'im', 1, {'im'});
tic
count=0;
handles.roi=[];
handles.roi.L=zeros(size(roi.L));
for i=1:size(roi.imrois,2)
    if size(roi.imrois(i).pixelinds,1)>=size_thresh
      count=count+1;
      handles.roi.imrois(count)=roi.imrois(i);
      handles.roi.imrois(count).index=count;
      for j=1:size(roi.imrois(i).pixelinds,1)
          handles.roi.L(roi.imrois(i).pixelinds(j))=count;
      end
    end
    progressbar(i/(size(roi.imrois,2)))
end
        
        
    

handles.roi.props =mia.z_old_archived_code.roi_properties(handles.roi.imrois, IMdata);
set(handles.text14,'String',length(handles.roi.props));
set(handles.listbox1,'userdata',handles.roi.imrois);

set(handles.text14,'userdata',handles.roi.props);
% set(handles.text54, 'userdata', imrois);
% set(handles.text10, 'userdata', L);

handles.roi.thresh=thresh;
handles.roi.size_thresh=size_thresh;
roi=handles.roi;
mydata=handles.mydata;
save(fullfilename,'BW','mydata','roi');

listbox1_update(hObject, eventdata, handles);
guidata(hObject,handles)
toc


function listbox1_update(hObject, eventdata, handles)
imrois = get(handles.listbox1,'userdata');
list_string = {};
for i=1:length(imrois),
    list_string{i} = ['ROI' int2str(i)]; 
end;
set(handles.listbox1,'string',list_string','value',1*(length(imrois)~=0));


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
myoldplot = findobj(handles.axes4,'tag','myplot');
if ~isempty(myoldplot), delete(myoldplot); end;
i = get(handles.listbox1,'value');
str = get(handles.listbox1,'string');
if isempty(i) | isempty(strtrim(str)), return; end;

    IMdata = readfullimage(hObject, eventdata, handles);
    zdim = get(handles.slider2,'value');
    
    for n = 1:numel(i),
        for j = i(n),  
            [roi2d, roi2dperim] = mia.z_old_archived_code.roi3d2dprojection(handles.roi.imrois(j).pixelinds, size(IMdata), zdim);
             if isempty(roi2dperim),
             else,
                for k=1:length(roi2dperim),
                    axes(handles.axes4)
                    hold on;
                    h=plot(roi2dperim{k}(:,2),roi2dperim{k}(:,1),'m','linewidth',1); 
                    set(h,'tag','myplot');
                end;
            end;
        end;
    end;
 
    if i<=length(props),
        set(handles.text13,'String',['ROI' int2str(i)]);
        set(handles.text22,'String',getfield(props,{1,i},'area'));
        set(handles.text23,'String',getfield(props,{1,i},'totalbrightness'));
        set(handles.text24,'String',getfield(props,{1,i},'averagebrightness'));
        set(handles.text25,'String',getfield(props,{1,i},'centreofmass'));
        set(handles.text26,'String',getfield(props,{1,i},'firstmomentofarea'));  
    end;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
showimage(hObject, eventdata, handles);

function updateimage(hObject, eventdata, handles)
a = get(handles.checkbox2, 'Value');
index_selected = get(handles.popupmenu5, 'Value');

    IMdata = readfullimage(hObject, eventdata, handles);
    zdim = get(handles.slider2,'value');
    color='g';
    if index_selected==2
        color='r';
    end
    
    if a
        for i=1:length(handles.roi.props),
            [roi2d, roi2dperim] = mia.z_old_archived_code.roi3d2dprojection(handles.roi.imrois(i).pixelinds, size(IMdata), zdim);
            axes(handles.axes4)
            hold on;
            if isempty(roi2dperim)
            else
            for j=1:length(roi2dperim),
                    h=plot(roi2dperim{j}(:,2),roi2dperim{j}(:,1),color,'linewidth',1); 
            end;
            end; 
        end; 
    end;


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if (get(handles.checkbox2,'Value') == get(handles.checkbox2,'Max')),
    updateimage(hObject, eventdata, handles);  
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
showimage(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles);
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Image 1';'Image 2'});


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5

index_selected = get(hObject, 'value');
[pathname,name,ext] = fileparts(handles.mydata.filename(index_selected,:));
fullfilename=strcat(handles.mydata.pathsave, '\', name, '.mat');
rois=load(fullfilename);
handles.roi=rois.roi;

set(handles.text14,'String',length(handles.roi.props));
set(handles.listbox1,'userdata',handles.roi.imrois);

set(handles.text14,'userdata',handles.roi.props);
% set(handles.text54, 'userdata', imrois);
% set(handles.text10, 'userdata', L);

listbox1_update(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'ROIs of Image 1';'ROIs of Image 2'});


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[pathname,name,ext] = fileparts(handles.mydata.filename(1,:));
handles.mydata.fullfilename1=strcat(handles.mydata.pathsave, '\', name, '.mat');
handles.mydata.colocfilename=strcat(handles.mydata.pathsave, '\', name, 'Coloc', '.mat');
rois1=load(handles.mydata.fullfilename1);

[pathname,name,ext] = fileparts(handles.mydata.filename(2,:));
handles.mydata.fullfilename2=strcat(handles.mydata.pathsave, '\', name, '.mat');
rois2=load(handles.mydata.fullfilename2);

tic

%handles.mydata.thresh = str2num(get(handles.edit1,'string'));

n = str2num(get(handles.edit19,'string')); 

xrange = [str2num(get(handles.edit20,'string')):1:str2num(get(handles.edit21,'string'))];
yrange = [str2num(get(handles.edit22,'string')):1:str2num(get(handles.edit23,'string'))];
zrange = [str2num(get(handles.edit24,'string')):1:str2num(get(handles.edit25,'string'))];

direction=get(handles.popupmenu6, 'value');

if direction==2
    [rois3dmerged, rois1.roi.L] = mia.z_old_archived_code.rois3dcat(rois1.roi.imrois,rois1.roi.L);
    [rois_overlap] = mia.z_old_archived_code.all_overlaps(rois3dmerged, rois2.roi.imrois,...
        rois1.roi.L, rois2.roi.L, n, xrange, yrange, zrange);
    handles.mydata.overlapfilename=strcat(handles.mydata.pathsave, '\', name, 'Overlap2on1', '.mat');
    handles.roi=rois2.roi;
else
    [rois3dmerged, rois2.roi.L] = mia.z_old_archived_code.rois3dcat(rois2.roi.imrois, rois2.roi.L);
    [rois_overlap] = mia.z_old_archived_code.all_overlaps(rois3dmerged, rois1.roi.imrois,...
        rois2.roi.L, rois1.roi.L, n, xrange, yrange, zrange);
    handles.mydata.overlapfilename=strcat(handles.mydata.pathsave, '\', name, 'Overlap1on2', '.mat');
    handles.roi=rois1.roi;
end;
toc
tic;
IMdata = readfullimage(hObject, eventdata, handles);
zdim = get(handles.slider2,'value');
color='y';

for i=1:length(rois_overlap.index),
    j=rois_overlap.index(i);
    [roi2d, roi2dperim] = mia.z_old_archived_code.roi3d2dprojection(handles.roi.imrois(j).pixelinds, size(IMdata), zdim);
     axes(handles.axes4)
     hold on;
     if isempty(roi2dperim)
     else
        for j=1:length(roi2dperim),
            h=plot(roi2dperim{j}(:,2),roi2dperim{j}(:,1),color,'linewidth',1); 
        end;
     end; 
     progressbar(i/(length(rois_overlap.index)))
end; 
toc


% set(handles.text68, 'userdata', overlap12);
% set(handles.text64, 'userdata', overlap21);

mydata=handles.mydata;
overlapfilename=handles.mydata.overlapfilename;
save(overlapfilename, 'mydata','rois1','rois2','rois_overlap', 'n', 'xrange', 'yrange', 'zrange');

guidata(hObject,handles)


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mydata.imagefile1 = strcat(handles.mydata.pathname,...
    handles.mydata.filename(1,:));
handles.mydata.imagefile2 = strcat(handles.mydata.pathname,...
    handles.mydata.filename(2,:));


im1=imread(handles.mydata.imagefile1,1);
im2=imread(handles.mydata.imagefile2,1);
colocfilename=handles.mydata.colocfilename;
overlapfilename=handles.mydata.overlapfilename;
overlap=load(overlapfilename);

coloc_thresh = str2num(get(handles.edit26,'string'));
i = get(handles.popupmenu6, 'value');

if i == 1,
    [roiscolocalization] = mia.z_old_archived_code.find_colocalization(overlap.overlap12, coloc_thresh);
    figure;
    coloc_num = numel(find(roiscolocalization == 1));
    rois_per_area = numel(coloc_num)/bwarea(im1);
    bar(rois_per_area);
else
    [roiscolocalization] = mia.z_old_archived_code.find_colocalization(overlap.overlap21, coloc_thresh);
end;

mydata=handles.mydata;
save(colocfilename, 'overlap', 'roiscolocalization', 'coloc_thresh', '-mat');

guidata(hObject,handles)


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Overlap12';'Overlap21'});


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename pathname] =uigetfile;
rois=load(fullfile(pathname,filename));
handles.roi=rois.roi;

set(handles.text14,'String',length(handles.roi.props));
set(handles.listbox1,'userdata',handles.roi.imrois);

set(handles.text14,'userdata',handles.roi.props);
% set(handles.text54, 'userdata', imrois);
% set(handles.text10, 'userdata', L);

listbox1_update(hObject, eventdata, handles);
guidata(hObject,handles)
