classdef creator

	properties
		output_types % types of objects that are created
		input_types % type of input
		iseditor % is this creator an editor of existing objects?
		default_parameters % the default parameters to be used
                parameter_list % cell array of parameter names
                parameter_descriptions % cell array of parameter descriptions for a human user
                parameter_selection_methods % selection methods by which user can choose parameters

		mdir % mia.miadir object
		input_name % input object name
		output_name % output object name

	end % properties

	methods
		function mia_creator_obj = creator(mdir, input_name, output_name)
			mia_creator_obj.input_types = {};
			mia_creator_obj.output_types = {}; % abstract creator does not make any objects
			mia_creator_obj.iseditor = 0;
			mia_creator_obj.default_parameters = struct([]); % empty struct
			mia_creator_obj.parameter_list = {};
			mia_creator_obj.parameter_descriptions = {};
			mia_creator_obj.parameter_selection_methods = {};

			if nargin>0,
				mia_creator_obj.mdir = mdir;
			end;
			if nargin>1,
				mia_creator_obj.input_name = input_name;
			end;
			if nargin>2,
				mia_creator_obj.output_name = output_name;
			end;
		end % creator()

		function [parameter_list, parameter_descriptions, parameter_selection_methods] = ...
			parameter_details(mia_creator_obj)
			% PARAMETER_DETAILS - obtain the details of the parameters for this creator
			%
			% [PARAMETER_LIST, PARAMETER_DESCRIPTIONS, PARAMETER_SELECTION_METHODS] = ...
			%   PARAMETER_DETAILS(MIA_CREATOR_OBJ)
			%
			% Returns the details of the parameters that are used to create objects.
			%
			% PARAMETER LIST is a cell array of all parameter names.
			%
			% PARAMETER_DESCRIPTIONS is a cell array the same size as PARAMETER_LIST that
			% has a human-readable description of parameters.
			%
			% PARAMETER_SELECTION_METHODS is a list of valid parameter selection methods
			%   for this class, such as 'choose_inputdlg' or 'choose_graphical'.
			%
				% in the abstract class, these are all empty	
				parameter_list = mia_creator_obj.parameter_list;
				parameter_descriptions = mia_creator_obj.parameter_descriptions;
				parameter_selection_methods = mia_creator_obj.parameter_selection_methods;
		end % parameter_details()

		function parameters = getuserparameters(mia_creator_obj, method, input_name, output_name)
			% GETUSERPARAMETERS - interactively obtain parameters from the user
			%
			% PARAMETERS = mia.creator.getuserparameters(METHOD, INPUT_NAME, OUTPUT_NAME)
			%
			% Interactively asks the user for parameters. If there is more than one
			% PARAMETER_SELECTION_METHOD (see mia.creator.parameter_details), then
			% the user is given a choice.
			%
				if nargin<2,
					method = 'choose';
				end;

				switch(method),
					case 'choose',
						[plist,pdesc,psel] = mia_creator_obj.parameter_details();
						choices = cat(2,psel,'Cancel');
						buttonname=questdlg('By which method should we choose parameters?',...
							'Which method?', choices{:}, 'Cancel');
						if ~strcmp(buttonname,'Cancel'),
							parameters = mia_creator_obj.getuserparameters(buttonname);
						else,
							parameters = struct([]); % empty
						end;
					case 'choose_inputdlg',
						parameters = mia_creator_obj.getuserparameters_choosedlg();
					case 'choose_graphical',
						parameters = mia_creator_obj.getuserparameters_graphical();
					otherwise,
						parameters = getuserparameters_nonstandard(mia_creator_obj, method);
				
				end; % switch
		end % getuserparameters()		
						
		function parameters = getuserparameters_nonstandard(mia_creator_obj, method)
			% GETUSERPARAMETERS_NONSTANDARD - select user parameters via a method other than 'choose_inputdlg' or 'choose_graphical'
			%
			% PARAMETERS = mia.creator.getuserparameters_nonstandard(method)
			%
			% Return the parameters via a method other than 'choose_inputdlg' or 'choose_graphical'.
			% 
			% In the base class, this returns an error because there are no other methods. It can
			% be overridden in subclasses to perform actions.
			%
			%
				error(['Unknown method ' method '.']);
		end % getuserparameters_nonstandard()

		function parameters = getuserparameters_choosedlg(mia_creator_obj)
			% GETUSERPARAMETERS_CHOOSEDLG - obtain parameters through a standard dialog box
			%
			% PARAMETERS = mia.creator.getuserparameters_choosedlg(MIA_CREATOR_OBJ)
			%
			% Obtain parameters by asking the user questions in a dialog box.
			%
			% If the user clicks cancel, PARAMETERS is empty.

				[plist,pdesc,psel] = mia_creator_obj.parameter_details();
				parameters = dlg2struct('Choose parameters',plist,pdesc,mia_creator_obj.default_parameters);
		end % getuserparameters_choosedlg(mia_creator_obj)

		function parameters = getuserparameters_graphical(mia_creator_obj)
			% GETUSERPARAMETERS_GRAPHICAL - obtain parameters through a graphical user interface window
			%
			% PARAMETERS = mia.creator.getuserparameters_graphical(MIA_CREATOR_OBJ);
			%
			% Opens a graphical user interface window to allow the user to graphically choose the parameters.
			%
				f = build_gui_parameterwindow(mia_creator_obj);
				success = process_gui_click(mia_creator_obj,f); % initial process without click
				while success == 0,
					uiwait();
					success = process_gui_click(mia_creator_obj,f);
				end;
				if success==1,
					parameters = gui2parameters(mia_creator_obj,f);
				else,
					parameters = [];
				end;
				close(f);
		end % getuserparameters_graphical(mia_creator_obj)

		function b = make(mia_creator_obj, input_name, output_name, parameters)
			% MAKE - make the object requested from the parameters given
			%
			% B = mia.creator.make(MIA_CREATOR_OBJ, INPUT_NAME, OUTPUT_NAME, PARAMETERS)
			%
			% Make the new object from the parameters, input name, and output name.
			%
			% B is 1 if the action succeeds, and 0 otherwise.
			%
				b = 0; % fails in abstract class
		end % make()

		function b = getuserparameters_and_make(mia_creator_obj)
			p = getuserparameters(mia_creator_obj, input_name, output_name);
			if ~isempty(p),
				b = mia_creator_obj.make(input_name,output_name,p);
			else,
				b = 0;
			end;
		end % getparameters_and_make

		function f = build_gui_parameterwindow(mia_creator_obj)
		end % build_gui_parameterwindow()

		function success = process_gui_click(mia_creator_obj, f)
			
		end % process_gui_click()
        
        function p = gui2parameters(mia_creator_obj)
		end % gui2parameters()

	end % methods
    
    methods (Static)
    end % static methods

end % classdef


