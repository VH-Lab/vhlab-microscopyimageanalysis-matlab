function s = wiseetal_readdata(metadata_file)


g = loadStructArray(metadata_file);

exper_types = {'irrev_exc','irrev_inh','structure'};

info_struct = vlt.data.emptystruct('exper_type','slice_num','stack_num', 'algorithm','fullpath','drug','time','animal','roi1','roi2','number','volumeroi1','volumeroi2','volunion');

for i=1:3 % numel(exper_types),

	switch(exper_types{i}),

		case 'irrev_exc',
			roi1 = {'BAS''};
			roi2 = {'PSD''};
		case 'irrev_inh',
			roi1 = {'GEPH'};
			roi2 = {'VGAT'};
		case 'structure',
			roi1 = {'BAS','VG'};
			roi2 = {'PSD', 'PSD'};
		end;
	
	T = readtable(g(i).blind);
	
	for j=1:size(T,1),
		slice_num = T{j,1};
		[drug,time,animal] = wiseexpstr2info(T{j,2}{1});
		
		fullpath_prefix = [g(i).path g(i).prefix int2str(slice_num) ];
		d = dir([fullpath_prefix filesep 'Stack *' ]);
		for k = 1:numel(d),
			for r=1:numel(roi1),
				fullpath = [fullpath_prefix filesep d(k).name filesep 'analysis'];
				[algorithm,numcoloc,vol_1,vol_2] = wiseetal_algorithms(fullpath, roi1{r}, roi2{r});
				for a = 1:numel(algorithm),
					clear istruct;
					istruct.exper_type = exper_types{i};
					istruct.slice_num = slice_num;
					istruct.stack_num = k;
					istruct.algorithm = algorithm(a);
					istruct.fullpath = fullpath;
					istruct.drug = drug;
					istruct.time = time;
					istruct.animal = animal;
					istruct.roi1 = roi1{r};
					istruct.roi2 = roi2{r};
					istruct.number = numcolor(a);
					istruct.volumeroi1 = vol_1(a);
					istruct.volumeroi2 = vol_2(a);
					istruct.volunion = [];
					info_struct(end+1) = istruct;
				end;
			end;
		end;
	end;
end;


s = info_struct;
