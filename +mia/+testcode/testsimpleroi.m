function testsimpleroi(pathname, itemname, deleteitemname, histitemname)
% TESTSIMPLEROI - a test code for ROIs in MIA.
%
%  MIA.TESTCODE.TESTSIMPLEROI(PATHNAME, ITEMNAME)
%
%  Takes in the PATHNAME of the ROI location, the ITEMNAME of the ROI,
%  Display the outputs of each function under mia.miadir class. 
% 
%% create miadir object
md = mia.miadir(pathname);

%% test deleteitem function
disp('========= test deleteitem function ============')
%mia.miadir.deleteitem(md, 'ROIs', deleteitemname);

%% test display function
disp('========= test display function ============')
mia.miadir.display(md);

%% test getcolocalizationfilename function
disp('========= test getcolocalizationfilename function ============')

%% test sethistory function
disp('========= test sethistory function ============')
newhistory = struct('parent',itemname,'operation','copy','parameters','',...
	'description',['This is a test of making the history']);
history = mia.miadir.sethistory(md, 'ROIs', histitemname, newhistory);
disp('You set the history of the file to be: ')
disp(newhistory);

%% test gethistory function
disp('========= test gethistory function ============')
h = mia.miadir.gethistory(md, 'ROIs', histitemname);
disp('we get the history of the file as: ')
disp(h);
if h == newhistory
    disp('The history you set is the same as the history we stored')
else 
    disp('The history you set is different from the history we stored')
end

%% test getitems function
disp('========= test getitems function ============')
G = mia.miadir.getitems(md, 'ROIs');
disp(G);
G_name = {G(:).name};
G_parent = {G(:).parent};
G_history = {G(:).history};
for i=1:length(G_name)
   disp(G_name{i});
   disp(G_parent{i});
   disp(G_history{i});
end

%% test getlabeledroifilename function
disp('========= test getlabeledroifilename function ============')
labeledroifilename = mia.miadir.getlabeledroifilename(md, itemname);
disp(labeledroifilename);

%% test getparent function
disp('========= test getparent function ============')
p = mia.miadir.getparent(md, 'ROIs', histitemname);
disp(p)

%% test getpathname function
disp('========= test getpathname function ============')
fixed_pathname = fixpath(pathname);               % The miadir constructor called fixpath on pathname
temp_pathname = mia.miadir.getpathname(md);
disp(fixed_pathname);
disp(temp_pathname);
if (temp_pathname == fixed_pathname),
    disp('getpathname is correct');
else,
    disp('getpathname is not correct');
end;

%% test getroifilename function
disp('========= test getroifilename function ============')
roifilename = mia.miadir.getroifilename(md, itemname);
disp(roifilename)

%% test getroiparametersfilename function
disp('========= test getroiparametersfilename function ============')
roipfilename = mia.miadir.getroiparametersfilename(md, itemname, true);
disp(roipfilename);