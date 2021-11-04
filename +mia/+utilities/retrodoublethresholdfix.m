function retrodoublethresholdfix(atd)
% RETRODOUBLETHRESHOLDFIX - update thresholded images obtained with at_double_threshold so they have more parameter information
%
% mia.utilities.retrodoublethresholdfix(ATD)
%
% 

itemstruct = mia.miadir.getitems(atd,'images');

for i=1:numel(itemstruct),
	if numel(itemstruct(i).history)>1,
		warning(['more than 1 item in history..surprised.']);
	end;
	if numel(itemstruct(i).history) & startsWith(itemstruct(i).history(1).operation,'at_image_double'),
		disp([itemstruct(i).name ': Found a double threshold']);

		if ~isfield(itemstruct(i).history(1).parameters,'thresholdinfo'),
			disp(['Lacks threshold info.']);
			im = mia.utilities.readimage(atd,itemstruct(i).parent);
			[th,out] = mia.utilities.estimatethresholds(im);
			out.signal_x, itemstruct(i).history(1).parameters.threshold1
			zind = findclosest(out.threshold_signal_to_noise,itemstruct(i).history(1).parameters.threshold1);
			out.detection_quality(zind),
			out2 = out;
			out2.t_levels = [out.detection_quality(zind) 30]
			itemstruct(i).history(1).parameters.thresholdinfo = out2;
			itemstruct(i).history(1),
			sethistory(atd,'images',itemstruct(i).name,itemstruct(i).history);
			
		end;
	end;
end;

 
