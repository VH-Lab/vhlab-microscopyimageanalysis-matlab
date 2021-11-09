function testsimplecla(pathname, itemname, deleteitemname, histitemname)
% TESTSIMPLECLA - a test code for CLAs in MIA.
%
%  MIA.TESTCODE.TESTSIMPLECLA(PATHNAME, ITEMNAME, DELETEITEMNAME)
%
%  Takes in the PATHNAME of the image location, the ITEMNAME of the image,
%  and the folder DELETEITEMNAME to be deleted.
%  Display the outputs of each function under mia.miadir class. 
% 
%% create miadir object
md = mia.miadir(pathname);

%% test deleteitem function
disp('========= test deleteitem function ============')
%mia.miadir.deleteitem(md, 'CLAs', deleteitemname);

%% test display function
disp('========= test display function ============')
mia.miadir.display(md);

%% test getcolocalizationfilename function
disp('========= test getcolocalizationfilename function ============')
cfilename = mia.miadir.getcolocalizationfilename(md, itemname);
disp(cfilename);
%% test sethistory function
disp('========= test sethistory function ============')
newhistory = struct('parent',itemname,'operation','copy','parameters','',...
	'description',['This is a test of making the history']);
history = mia.miadir.sethistory(md, 'CLAs', histitemname, newhistory);
disp('You set the history of the file to be: ')
disp(newhistory);

%% test gethistory function
disp('========= test gethistory function ============')
h = mia.miadir.gethistory(md, 'CLAs', histitemname);
disp('we get the history of the file as: ')
disp(h);
if h == newhistory
    disp('The history you set is the same as the history we stored')
else 
    disp('The history you set is different from the history we stored')
end

%% test getitems function
disp('========= test getitems function ============')
G = mia.miadir.getitems(md, 'CLAs');
disp(G);
G_name = {G(:).name};
G_parent = {G(:).parent};
G_history = {G(:).history};
for i=1:length(G_name)
   disp(G_name{i});
   disp(G_parent{i});
   disp(G_history{i});
end
%% test getparent function
disp('========= test getparent function ============')
p = mia.miadir.getparent(md, 'CLAs', histitemname);
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




