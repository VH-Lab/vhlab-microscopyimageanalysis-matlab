function testsimpleimage(pathname, itemname)
% TESTSIMPLEIMAGE - a test code for images in MIA.
%
%  MIA.TESTCODE.TESTSIMPLEIMAGE(PATHNAME, ITEMNAME)
%
%  Takes in the PATHNAME of the image location, and the ITEMNAME of the image.
%  Display the outputs of each function under mia.miadir class. 
% 
%% create miadir object
md = mia.miadir(pathname);

%% test addtag function
%% test deleteitem function
%% test display function
disp('========= test display function ============')
mia.miadir.display(md);

%% test getcolocalizationfilename function
%% test gethistory function
%% test getimagefilename function
disp('========= test getimagefilename function ============');
imfilename = getimagefilename(md, itemname);
disp(imfilename);
%% test getitems function
disp('========= test getitems function ============')
G = mia.miadir.getitems(md, 'images');
disp(G);
G_name = {G(:).name};
for i=1:length(G_name)
   disp(G_name{i});
end
G_parent = {G(:).parent};
for i=1:length(G_parent)
   disp(G_parent{i});
end
G_history = {G(:).history};
for i=1:length(G_history)
   disp(G_history{i});
end
%% test getlabeledroifilename function
%% test getparent function
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



