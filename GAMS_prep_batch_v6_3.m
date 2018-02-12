%%  RODeO batch Prep file
%
%     Creates batch file by quickly assembling different sets of runs and 
%       can create multiple batch files for parallel processing
%
%     Steps to add new fields
%       1. Add entry into Batch_header (Second section)
%       2. Add value(s) for new fields (Third section)


%% Prepare data to populate batch file.
clear all, close all, clc


Project_name = 'Central_vs_distributed';
% Project_name = 'Example';

dir1 = 'C:\Users\jeichman\Documents\gamsdir\projdir\RODeO\';   % Set directory to send files
dir2 = [dir1,'Projects\',Project_name,'\Batch_files\'];
cd(dir1); 

% Define overall properties
GAMS_loc = 'C:\GAMS\win64\24.8\gams.exe';
GAMS_file= {'Storage_dispatch_v22_1'};      % Define below for each utility (3 file options)
GAMS_lic = 'license=C:\GAMS\win64\24.8\gamslice.txt';
files_to_create = 1;  % Select the number of batch files to create

outdir = ['Projects\',Project_name,'\Output'];
indir  = ['Projects\',Project_name,'\Data_files\TXT_files'];

% Load filenames
files_tariff = dir([dir1,indir]);
files_tariff2={files_tariff.name}';             % Identify files in a folder    
load_file1 = zeros(1,length(files_tariff2));    % Initialize matrix
for i0=1:length(files_tariff2)                  % Remove items from list that do not fit criteria
    if ((~isempty(strfind(files_tariff2{i0},'additional_parameters'))+...
         ~isempty(strfind(files_tariff2{i0},'renewable_profiles'))+...
         ~isempty(strfind(files_tariff2{i0},'controller_input_values'))+...
         ~isempty(strfind(files_tariff2{i0},'building')))>0)     % Skip files called "additional_parameters" or "renewable profile" 
    else
        load_file1(i0)=~isempty(strfind(files_tariff2{i0},'.txt'));       % Find only txt files
    end
end 
files_tariff2=files_tariff2(find(load_file1));    clear load_file1 files_tariff

files_add_load = dir([dir1,indir]);
files_add_load2={files_add_load.name}';         % Identify files in a folder
load_file1 = zeros(1,length(files_add_load2));  % Initialize matrix
for i0=1:length(files_add_load2)                % Remove items from list that do not fit criteria
    if ~isempty(strfind(files_add_load2{i0},'Additional_load')>0)
        load_file1(i0)=~isempty(strfind(files_add_load2{i0},'.csv'));	 % Find only Additional load csv files        
    end
end 
files_add_load2=files_add_load2(find(load_file1));    clear load_file1 files_add_load


%% Set values to vary by scenario
if strcmp(Project_name,'Central_vs_distributed')
%% Central_vs_distributed
    Batch_header.elec_rate_instance.val = strrep(files_tariff2,'.txt','');
    Batch_header.H2_consumed_instance.val = {'H2_consumption_central_hourly','H2_consumption_distributed_hourly'};        
    Batch_header.baseload_pwr_instance.val = {'Input_power_baseload_hourly'};        
    Batch_header.NG_price_instance.val = {'NG_price_Price1_hourly'};        
    Batch_header.ren_prof_instance.val = {'renewable_profiles_none_hourly'};
    Batch_header.load_prof_instance.val = strrep(files_add_load2,'.csv','');
    Batch_header.energy_price_inst.val = {'Energy_prices_empty_hourly'};
    Batch_header.AS_price_inst.val = {'Ancillary_services_hourly'};
    [status,msg] = mkdir(outdir);       % Create output file if it doesn't exist yet  
    Batch_header.outdir.val = {outdir}; % Reference is dynamic from location of batch file (i.e., exclue 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)
    Batch_header.indir.val = {indir};   % Reference is dynamic from location of batch file (i.e., exclue 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)

    Batch_header.gas_price_instance.val = {'NA'};
    Batch_header.zone_instance.val = {'NA'};
    Batch_header.year_instance.val = {'NA'};

    % Input capacity and location relationship
    [~,~,raw0]=xlsread([indir,'\Match_inputcap_station']);  % Load file(s) 
    header1 = raw0(1,:);                                    % Pull out header file
    raw0 = raw0(2:end,:);                                   % Remove first row
    raw0 = cellfun(@num2str,raw0,'UniformOutput',false);    % Convert any numbers to strings
    input_cap_instance_values = unique(raw0(:,1));          % Find unique capacity values
    
    Batch_header.input_cap_instance.val = input_cap_instance_values';
    Batch_header.output_cap_instance.val = {'0'};
    Batch_header.price_cap_instance.val = {'10000'};

    Batch_header.Apply_input_cap_inst.val = {'0'};
    Batch_header.Apply_output_cap_inst.val = {'0'};
    Batch_header.max_output_cap_inst.val = {'inf'};
    Batch_header.allow_import_instance.val = {'1'};

    Batch_header.input_LSL_instance.val = {'0.1'};
    Batch_header.output_LSL_instance.val = {'0'};
    Batch_header.Input_start_cost_inst.val = {'0'};
    Batch_header.Output_start_cost_inst.val = {'0'};
    Batch_header.input_efficiency_inst.val = {'0.613668913'};
    Batch_header.output_efficiency_inst.val = {'1'};

    Batch_header.input_cap_cost_inst.val = {'0'};
    Batch_header.output_cap_cost_inst.val = {'0'};
    Batch_header.input_FOM_cost_inst.val = {'0'};
    Batch_header.output_FOM_cost_inst.val = {'0'};
    Batch_header.input_VOM_cost_inst.val = {'0'};
    Batch_header.output_VOM_cost_inst.val = {'0'};
    Batch_header.input_lifetime_inst.val = {'0'};
    Batch_header.output_lifetime_inst.val = {'0'};
    Batch_header.interest_rate_inst.val = {'0'};

    Batch_header.in_heat_rate_instance.val = {'0'};
    Batch_header.out_heat_rate_instance.val = {'0'};
    Batch_header.storage_cap_instance.val = {'24'};
    Batch_header.storage_set_instance.val = {'1'};
    Batch_header.storage_init_instance.val = {'0.5'};
    Batch_header.storage_final_instance.val = {'0.5'};
    Batch_header.reg_cost_instance.val = {'0'};
    Batch_header.min_runtime_instance.val = {'0'};
    Batch_header.ramp_penalty_instance.val = {'0'};

    Batch_header.op_length_instance.val = {'8760'};
    Batch_header.op_period_instance.val = {'8760'};
    Batch_header.int_length_instance.val = {'1'};

    Batch_header.lookahead_instance.val = {'0'};
    Batch_header.energy_only_instance.val = {'1'};        
    Batch_header.file_name_instance.val = {'0'};    % 'file_name_instance' created in the next section (default value of 0)
    Batch_header.H2_consume_adj_inst.val = {'1','0.9'};
    Batch_header.H2_price_instance.val = {'6'};
    Batch_header.H2_use_instance.val = {'1'};
    Batch_header.base_op_instance.val = {'0'};
    Batch_header.NG_price_adj_instance.val = {'1'};
    Batch_header.Renewable_MW_instance.val = {'0'};

    Batch_header.CF_opt_instance.val = {'0'};
    Batch_header.run_retail_instance.val = {'1'};
    Batch_header.one_active_device_inst.val = {'1'};

    Batch_header.current_int_instance.val = {'-1'};
    Batch_header.next_int_instance.val = {'1'};
    Batch_header.current_stor_intance.val = {'0.5'};
    Batch_header.current_max_instance.val = {'0.8'};
    Batch_header.max_int_instance.val = {'Inf'};
    Batch_header.read_MPC_file_instance.val = {'0'}; 
elseif strcmp(Project_name,'Example')
%% Example
    Batch_header.elec_rate_instance.val         = strrep(files_tariff2,'.txt','');
    Batch_header.H2_consumed_instance.val       = {'H2_consumption_flat_hourly'};        
    Batch_header.baseload_pwr_instance.val      = {'Input_power_baseload_hourly'};        
    Batch_header.NG_price_instance.val          = {'NG_price_Price1_hourly'};        
    Batch_header.ren_prof_instance.val          = {'renewable_profiles_none_hourly'};
    Batch_header.load_prof_instance.val         = {'Additional_load_Station1_hourly'};
    Batch_header.energy_price_inst.val          = {'Energy_prices_empty_hourly'};
    Batch_header.AS_price_inst.val              = {'Ancillary_services_hourly'};
    [status,msg] = mkdir(outdir);       % Create output file if it doesn't exist yet  
    Batch_header.outdir.val = {outdir}; % Reference is dynamic from location of batch file (i.e., exclue 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)
    Batch_header.indir.val = {indir};   % Reference is dynamic from location of batch file (i.e., exclue 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)

    Batch_header.gas_price_instance.val         = {'NA'};
    Batch_header.zone_instance.val              = {'NA'};
    Batch_header.year_instance.val              = {'NA'};

    Batch_header.input_cap_instance.val         = {'0','1300','2600','3900'};
    Batch_header.output_cap_instance.val        = {'0'};
    Batch_header.price_cap_instance.val         = {'10000'};

    Batch_header.Apply_input_cap_inst.val       = {'0'};
    Batch_header.Apply_output_cap_inst.val      = {'0'};
    Batch_header.max_output_cap_inst.val        = {'inf'};
    Batch_header.allow_import_instance.val      = {'1'};

    Batch_header.input_LSL_instance.val         = {'0.1'};
    Batch_header.output_LSL_instance.val        = {'0'};
    Batch_header.Input_start_cost_inst.val      = {'0'};
    Batch_header.Output_start_cost_inst.val     = {'0'};
    Batch_header.input_efficiency_inst.val      = {'1'};
    Batch_header.output_efficiency_inst.val     = {'1'};

    Batch_header.input_cap_cost_inst.val        = {'0'};
    Batch_header.output_cap_cost_inst.val       = {'0'};
    Batch_header.input_FOM_cost_inst.val        = {'0'};
    Batch_header.output_FOM_cost_inst.val       = {'0'};
    Batch_header.input_VOM_cost_inst.val        = {'0'};
    Batch_header.output_VOM_cost_inst.val       = {'0'};
    Batch_header.input_lifetime_inst.val        = {'0'};
    Batch_header.output_lifetime_inst.val       = {'0'};
    Batch_header.interest_rate_inst.val         = {'0'};

    Batch_header.in_heat_rate_instance.val      = {'0'};
    Batch_header.out_heat_rate_instance.val     = {'0'};
    Batch_header.storage_cap_instance.val       = {'6'};
    Batch_header.storage_set_instance.val       = {'1'};
    Batch_header.storage_init_instance.val      = {'0.5'};
    Batch_header.storage_final_instance.val     = {'0.5'};
    Batch_header.reg_cost_instance.val          = {'0'};
    Batch_header.min_runtime_instance.val       = {'0'};
    Batch_header.ramp_penalty_instance.val      = {'0'};

    Batch_header.op_length_instance.val         = {'8760'};
    Batch_header.op_period_instance.val         = {'8760'};
    Batch_header.int_length_instance.val        = {'1'};

    Batch_header.lookahead_instance.val         = {'0'};
    Batch_header.energy_only_instance.val       = {'1'};        
    Batch_header.file_name_instance.val         = {'0'};    % 'file_name_instance' created in the next section (default value of 0)
    Batch_header.H2_consume_adj_inst.val        = {'0.97','0.95','0.9','0.8'};
    Batch_header.H2_price_instance.val          = {'6'};
    Batch_header.H2_use_instance.val            = {'1'};
    Batch_header.base_op_instance.val           = {'0'};
    Batch_header.NG_price_adj_instance.val      = {'1'};
    Batch_header.Renewable_MW_instance.val      = {'0'};

    Batch_header.CF_opt_instance.val            = {'0'};
    Batch_header.run_retail_instance.val        = {'1'};
    Batch_header.one_active_device_inst.val     = {'1'};

    Batch_header.current_int_instance.val       = {'-1'};
    Batch_header.next_int_instance.val          = {'1'};
    Batch_header.current_stor_intance.val       = {'0.5'};
    Batch_header.current_max_instance.val       = {'0.8'};
    Batch_header.max_int_instance.val           = {'Inf'};
    Batch_header.read_MPC_file_instance.val     = {'0'};
else
%% Default
    Batch_header.elec_rate_instance.val = strrep(files_tariff2,'.txt','');
    Batch_header.H2_price_hourly.val = {'additional_parameters_hourly'};        
    Batch_header.H2_consumed_instance.val = {'H2_consumption_hourly'};        
    Batch_header.baseload_pwr_instance.val = {'Input_power_baseload_hourly'};        
    Batch_header.NG_price_instance.val = {'NG_price_hourly'};        
    Batch_header.ren_prof_instance.val = {'renewable_profiles_none_hourly'};
    Batch_header.load_prof_instance.val = {'Additional_load_hourly'};
    Batch_header.energy_price_inst.val = {'Energy_prices_hourly'};
    Batch_header.AS_price_inst.val = {'Ancillary_services_hourly'};
    [status,msg] = mkdir(outdir);           % Create output file if it doesn't exist yet  
    Batch_header.outdir.val = {outdir};     % Reference is dynamic from location of batch file (i.e., exclude 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)
    Batch_header.indir.val = {indir};       % Reference is dynamic from location of batch file (i.e., exclude 'RODeO\' in the filename for batch runs but include for runs within GAMS GUI)

    Batch_header.gas_price_instance.val = {'NA'};
    Batch_header.zone_instance.val = {'NA'};
    Batch_header.year_instance.val = {'NA'};

    Batch_header.input_cap_instance.val = {'1000'};
    Batch_header.output_cap_instance.val = {'0'};
    Batch_header.price_cap_instance.val = {'10000'};

    Batch_header.Apply_input_cap_inst.val = {'0'};
    Batch_header.Apply_output_cap_inst.val = {'0'};
    Batch_header.max_output_cap_inst.val = {'inf'};
    Batch_header.allow_import_instance.val = {'1'};

    Batch_header.input_LSL_instance.val = {'0.1'};
    Batch_header.output_LSL_instance.val = {'0'};
    Batch_header.Input_start_cost_inst.val = {'0'};
    Batch_header.Output_start_cost_inst.val = {'0'};
    Batch_header.input_efficiency_inst.val = {'0.613668913'};
    Batch_header.output_efficiency_inst.val = {'1'};

    Batch_header.input_cap_cost_inst.val = {'0'};
    Batch_header.output_cap_cost_inst.val = {'0'};
    Batch_header.input_FOM_cost_inst.val = {'0'};
    Batch_header.output_FOM_cost_inst.val = {'0'};
    Batch_header.input_VOM_cost_inst.val = {'0'};
    Batch_header.output_VOM_cost_inst.val = {'0'};
    Batch_header.input_lifetime_inst.val = {'0'};
    Batch_header.output_lifetime_inst.val = {'0'};
    Batch_header.interest_rate_inst.val = {'0'};

    Batch_header.in_heat_rate_instance.val = {'0'};
    Batch_header.out_heat_rate_instance.val = {'0'};
    Batch_header.storage_cap_instance.val = {'6'};
    Batch_header.storage_set_instance.val = {'1'};
    Batch_header.storage_init_instance.val = {'0.5'};
    Batch_header.storage_final_instance.val = {'0.5'};
    Batch_header.reg_cost_instance.val = {'0'};
    Batch_header.min_runtime_instance.val = {'0'};
    Batch_header.ramp_penalty_instance.val = {'0'};

    Batch_header.op_length_instance.val = {'8760'};
    Batch_header.op_period_instance.val = {'8760'};
    Batch_header.int_length_instance.val = {'1'};

    Batch_header.lookahead_instance.val = {'0'};
    Batch_header.energy_only_instance.val = {'1'};        
    Batch_header.file_name_instance.val = {'0'};    % 'file_name_instance' created in the next section (default value of 0)
    Batch_header.H2_consume_adj_inst.val = {'0.9'};
    Batch_header.H2_price_instance.val = {'6'};
    Batch_header.H2_use_instance.val = {'1'};
    Batch_header.base_op_instance.val = {'0','1'};
    Batch_header.NG_price_adj_instance.val = {'1'};
    Batch_header.Renewable_MW_instance.val = {'0'};

    Batch_header.CF_opt_instance.val = {'0'};
    Batch_header.run_retail_instance.val = {'1'};
    Batch_header.one_active_device_inst.val = {'1'};

    Batch_header.current_int_instance.val = {'-1'};
    Batch_header.next_int_instance.val = {'1'};
    Batch_header.current_stor_intance.val = {'0.5'};
    Batch_header.current_max_instance.val = {'0.8'};
    Batch_header.max_int_instance.val = {'Inf'};
    Batch_header.read_MPC_file_instance.val = {'0'};
end

fields1 = fieldnames(Batch_header);
relationship_length = zeros(numel(fields1),1);      % Create matrix to track size of variations for each variable
for i0=1:numel(fields1)
    relationship_length(i0) = length(Batch_header.(fields1{i0}).val);
end

% Create 2D matrix of all possible combinations
relationship_matrix = [];
for i0=1:numel(fields1)
    num_items = numel(Batch_header.(fields1{i0}).val);
    if i0==1,
        relationship_matrix = Batch_header.(fields1{i0}).val;
    else
        [M0,N0] = size(relationship_matrix);               
        relationship_matrix_interim = relationship_matrix;  % Copy matrix to repeat
        fields1_val = Batch_header.(fields1{i0}).val;       % Capture all values for selected field        
        for i1=1:num_items
            add_column = cell(M0,1);                        % Create empty matrix to add to existing matrix
            [add_column{:}] = deal([fields1_val{i1}]);      % Populate matrix with repeated cell item
            relationship_matrix_interim([(i1-1)*M0+1:i1*M0],[1:(N0+1)]) = horzcat(relationship_matrix,add_column); 
        end
        relationship_matrix = relationship_matrix_interim;  % Overwrite matrix with completed 
    end   
end
clear i0 M0 N0 add_column

%% Define how values are varied between fields
%  Not defining how a field1 is varied over field2 causes the code to default to making the same values for field1 across every field2 
%  Example: F1 = {'0','1'}, F2 = {'10','100'}. Without defining a specific relationship between F1 and F2, four runs will be created (i.e., [F1=0,F2=10], [F1=0,F2=100], [F1=1,F2=10], [F0=1,F1=100])
%  Definition of relationship should be arranged as e.g., input_cap_instance.base_op_instance. 
%  The first item is the row and the second is the column.
%  Example: input_cap_instance = {'900','1000'}; base_op_instance = {'0','1'};
%  Exapmle: The resulting matrix would be         C1        C2
%                                           R1    [900,0]   [900,1]
%                                           R2    [1000,0]  [1000,1]
%  Example: Create matrix to express the items that you want (1=include, 0 = exclude) 
%  Example: Batch_header.input_cap_instance.base_op_instance = [0 1;1 0]; 
%  Setup to work for multiple relationships per field

% Define relationships between fields 
%   (only define one relationship per field)
%   (Do not define the reciprocal relationship... if -> Batch_header.A.B then do not define Batch_header.B.A)

if strcmp(Project_name,'Central_vs_distributed')
% Central_vs_distributed
    V1 = length(Batch_header.input_cap_instance.val);
    V2 = length(Batch_header.H2_consume_adj_inst.val);
    V3 = length(Batch_header.load_prof_instance.val);
    V4 = length(Batch_header.H2_consumed_instance.val);
    V5 = length(Batch_header.elec_rate_instance.val);
         
    % Each file constructs relationship between two fields (field names should be in first row)
    load_files1 = {'Match_inputcap_CF','Match_inputcap_load','Match_inputcap_rates','Match_inputcap_H2Cons','Match_load_rates'};    
    Batch_header = load_relation_file(load_files1,indir,Batch_header);   % Run function file load_relation_file
elseif strcmp(Project_name,'Example')
% Example
    Batch_header.input_cap_instance.H2_consume_adj_inst = [1,0,0,0;1,1,1,1;1,1,1,1;1,1,1,1];
else   
% Default
end

%% Adjust relationship matrix based on definitions above
relationship_toggle = ones(prod(relationship_length),1);            % Matrix to turn on and off specific runs (1=include, 0=exclude) (default, before applying exceptions, is to include all runs)
for i0=1:numel(fields1)
    fields2 = fieldnames(Batch_header.(fields1{i0}));
    [M0,N0] = size(fields2);
    if M0==1, continue
    else
        for i1=2:M0
            find_index1 = i0;                                       % Repeat value for i0
            find_index2 = strfind(fields1,fields2(i1));             % Find string in cell array 
            find_index2 = find(not(cellfun('isempty',find_index2)));% Find string in cell array 
            
            find_val1 = Batch_header.(fields1{find_index1}).val;    % Find values in row
            find_val2 = Batch_header.(fields1{find_index2}).val;    % Find values in column
            
            find_rel1 = Batch_header.(fields1{find_index1}).(fields1{find_index2});  % Find relationship between items
            [M1,N1] = size(find_rel1);
          
            for i2=1:M1
                for i3=1:N1
                    find_rel1_val = find_rel1(i2,i3);
                    if find_rel1_val==0
                        find_val3 = {find_val1{i2},find_val2{i3}};
                        compare_fields1 = horzcat(relationship_matrix(:,find_index1),relationship_matrix(:,find_index2));
                        find_row1 = strcmp(relationship_matrix(:,find_index1),find_val1{i2});  % Find rows that match omitted items

                        find_row2 = strcmp(relationship_matrix(:,find_index2),find_val2{i3});  % Find rows that match omitted items
                        
                        remove_items = (find_row1+find_row2)>=2;
                        relationship_toggle(remove_items) = 0;
                    end                    
                end
            end            
        end
    end
end
clear i0 i1 i2 i3 M0 N0 M1 N1 compare_fields1 find_row1 find_row2
relationship_matrix_final = relationship_matrix;
relationship_matrix_final(find(relationship_toggle==0),:)=[];
[M0,N0] = size(relationship_matrix_final);

% Create file names
if strcmp(Project_name,'Central_vs_distributed')
%% Central_vs_distributed
    Index_file_name = strfind(fields1,'file_name_instance');    Index_file_name = find(not(cellfun('isempty',Index_file_name)));
    Index_elec_rate = strfind(fields1,'elec_rate_instance');    Index_elec_rate = find(not(cellfun('isempty',Index_elec_rate)));
    Index_base = strfind(fields1,'base_op_instance');           Index_base = find(not(cellfun('isempty',Index_base)));
    Index_CF = strfind(fields1,'H2_consume_adj_inst');          Index_CF = find(not(cellfun('isempty',Index_CF)));
    Index_H2_cons = strfind(fields1,'H2_consumed_instance');    Index_H2_cons = find(not(cellfun('isempty',Index_H2_cons)));
    Index_load = strfind(fields1,'load_prof_instance');         Index_load = find(not(cellfun('isempty',Index_load)));
    Index_input_cap = strfind(fields1,'input_cap_instance');    Index_input_cap = find(not(cellfun('isempty',Index_input_cap)));

    for i0=1:M0    
        interim1 = relationship_matrix_final{i0,Index_elec_rate};
        Find_underscore1 = strfind(interim1,'_');
        interim1 = interim1(1:Find_underscore1-1);    

        interim2 = relationship_matrix_final{i0,Index_load};
        interim2 = strrep(interim2,'Additional_load_','');
        interim2 = strrep(interim2,'_hourly','');
        interim2 = strrep(interim2,'Central','');
        interim2 = strrep(interim2,'Dist','');
        if strcmp(interim2,'none')==1               % If value is none then change
            Index_location = strfind(raw0(:,1),relationship_matrix_final{i0,Index_input_cap});
            Index_location = find(not(cellfun('isempty',Index_location)));
            interim2 = [raw0{Index_location,2}];
        end

        interim3 = relationship_matrix_final{i0,Index_CF};
        interim3 = ['CF',num2str(round(str2num(interim3)*100,0))];

        interim4 = relationship_matrix_final{i0,Index_H2_cons};
        if strcmp(interim4,'H2_consumption_central_hourly'),     interim4='Central';
        elseif strcmp(interim4,'H2_consumption_distributed_hourly'), interim4='Distributed';
        end
        relationship_matrix_final{i0,Index_file_name} = horzcat(interim1,'_',interim2,'_',interim3,'_',interim4);
    end
elseif strcmp(Project_name,'Example')
%% Example
    Index_file_name = strfind(fields1,'file_name_instance');    Index_file_name = find(not(cellfun('isempty',Index_file_name)));
    Index_elec_rate = strfind(fields1,'elec_rate_instance');    Index_elec_rate = find(not(cellfun('isempty',Index_elec_rate)));
    Index_base = strfind(fields1,'base_op_instance');           Index_base = find(not(cellfun('isempty',Index_base)));
    Index_CF = strfind(fields1,'H2_consume_adj_inst');          Index_CF = find(not(cellfun('isempty',Index_CF)));
    Index_input_cap = strfind(fields1,'input_cap_instance');    Index_input_cap = find(not(cellfun('isempty',Index_input_cap)));

    for i0=1:M0    
        interim1 = relationship_matrix_final{i0,Index_elec_rate};
        Find_underscore1 = strfind(interim1,'_');
        interim1 = interim1(1:Find_underscore1-1);    

        interim2 = relationship_matrix_final{i0,Index_input_cap};
        if strcmp(interim2,'0'),     interim2='NoDevice';
        else                         interim2=['Flex',num2str(relationship_matrix_final{i0,Index_input_cap})];
        end

        interim3 = relationship_matrix_final{i0,Index_CF};
        interim3 = ['CF',num2str(round(str2num(interim3)*100,0))];

        relationship_matrix_final{i0,Index_file_name} = horzcat(interim1,'_',interim2,'_',interim3);
    end
else   
%% Default
end


%% Create batch file names for tariffs
c2=1;   % Initialize batch file number
fileID = fopen([dir2,['RODeO_batch',num2str(c2),'.bat']],'wt');

% Create GAMS run command and write to text file
for i0=1:M0
GAMS_batch_init = ['"',GAMS_loc,'" "',GAMS_file,'" ',GAMS_lic];
    for i1=1:N0
        GAMS_batch{i1,1} = horzcat([' --',fields1{i1},'="',relationship_matrix_final{i0,i1},'"']);        
    end
    fprintf(fileID,'%s\n\n',[[GAMS_batch_init{:}],[GAMS_batch{:}]]);
    if mod(i0,ceil(M0/files_to_create))==0
        if i0==M0
        else
            fclose(fileID);
            c2=c2+1;            
            fileID = fopen([dir2,['RODeO_batch',num2str(c2),'.bat']],'wt');
        end
    end 
    if mod(i0,100)==0
        disp(['File ',num2str(c2),' : ',num2str(i0),' of ',num2str(M0)]);   % Display progress    
    end    
end
fclose(fileID);
disp([num2str(c2),' batch files created for ',num2str(M0),' model runs (~',num2str(ceil(M0/files_to_create)),' each)']);


%% Function file
% function Batch_header = load_relation_file(load_file1,indir,Batch_header)
%         [~,~,raw1] = xlsread([indir,'\',load_file1]);   % Load file 
%         header1 = raw1(1,:);                                    % Pull out header file
%         raw1 = raw1(2:end,:);                                   % Remove first row
%         raw1 = cellfun(@num2str,raw1,'UniformOutput',false);    % Convert any numbers to strings
%         [M0,~] = size(raw1);                                    % Find size
%         
%         V1 = length(Batch_header.(header1{1}).val);
%         V2 = length(Batch_header.(header1{2}).val);    
%         Int1 = zeros(V1,V2);                                    % Initialize matrix
%         for i0=1:V1
%             for i1=1:V2
%                 for i2=1:M0
%                     eval(sprintf('if (strcmp(Batch_header.%s.val{%d},raw1{%d,1}) && strcmp(Batch_header.%s.val{%d},raw1{%d,2}) ), Int1(%d,%d) = 1; end',header1{1},i0,i2,header1{2},i1,i2,i0,i1))
%     % LEGACY                      if (strcmp(Batch_header.elec_rate_instance.val{i0},raw1{i2,1}) && strcmp(Batch_header.load_prof_instance.val{i1},raw1{i2,2}) ), Int1(i0,i1) = 1; end
%                 end
%             end
%         end
%         eval(sprintf('Batch_header.%s.%s = Int1;',header1{1},header1{2}))
%     % LEGACY          Batch_header.elec_rate_instance.load_prof_instance = Int1;
% end