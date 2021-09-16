function build()
% mia.docs.build - build the mia markdown documentation from Matlab source
%
% Builds the mia documentation locally in vhlab-ArrayTomography-toolbox/docs and updates the mkdocs-yml file
% in the $NDR-matlab directory.
%
% **Example**:
%   mia.docs.build();
%

  % first, get the directory of mia
  
w = which('mia.docs.build');
[parentdir,fname]= fileparts(w);
[parentparent,fname2] = fileparts(parentdir);
[parentparentparent,fname3] = fileparts(parentparent);
mia_path = parentparentparent;

disp(['Now writing function reference...']);

mia_docs = [mia_path filesep 'docs' filesep 'reference']; % code reference path
ymlpath = 'reference';

disp(['Writing documents pass 1']);

out1 = vlt.docs.matlab2markdown(mia_path,mia_docs,ymlpath);
os = vlt.docs.markdownoutput2objectstruct(out1); % get object structures

disp(['Writing documents pass 2, with all links']);
out2 = vlt.docs.matlab2markdown(mia_path,mia_docs,ymlpath, os);

T = vlt.docs.mkdocsnavtext(out2,4);

ymlfile.references = [mia_path filesep 'docs' filesep 'mkdocs-references.yml'];
ymlfile.start = [mia_path filesep 'docs' filesep 'mkdocs-start.yml'];
ymlfile.end = [mia_path filesep 'docs' filesep 'mkdocs-end.yml'];
ymlfile.main = [mia_path filesep 'mkdocs.yml'];

vlt.file.str2text(ymlfile.references,T);

T0 = vlt.file.text2cellstr(ymlfile.start);
T1 = vlt.file.text2cellstr(ymlfile.references);
T2 = vlt.file.text2cellstr(ymlfile.end);

Tnew = cat(2,T0,T1,T2);

vlt.file.cellstr2text(ymlfile.main,Tnew);

