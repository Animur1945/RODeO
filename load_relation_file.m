%% GAMS_batch_func
%  Takes a file that relates two fields and turns it into a constraint that can be read by the script

function Batch_header = load_relation_file(load_files1,indir,Batch_header)
        for i0=1:length(load_files1)
            [~,~,raw1] = xlsread([indir,'\',load_files1{i0}]);      % Load file(s) 
            header1 = raw1(1,:);                                    % Pull out header file
            raw1 = raw1(2:end,:);                                   % Remove first row
            raw1 = cellfun(@num2str,raw1,'UniformOutput',false);    % Convert any numbers to strings
            [M0,~] = size(raw1);                                    % Find size

            V1 = length(Batch_header.(header1{1}).val);
            V2 = length(Batch_header.(header1{2}).val);    

            %%% Check to make sure all values are defined to avoid inadvertantly deleting scenarios
            V1_int = unique(raw1(:,1));         % Find length of unique non-'NaN' array
            V1_int(strcmp(V1_int,'NaN')) = [];            
            V1_check = length(V1_int);
            
            V2_int = unique(raw1(:,2));         % Find length of unique non-'NaN' array
            V2_int(strcmp(V2_int,'NaN')) = [];            
            V2_check = length(V2_int);
            
            % Warnings below do not necessarily mean an error. Ignore if this is intentional (e.g., have more electricity rate files than are used)
            % V1_check or V2_check can be larger than V1 or V2
            if (V1_check~=V1)
               warning([header1{1},' from ',load_files1{i0},'.xlsx has fewer values than initially defined (',num2str(V1_check),' out of ',num2str(V1),')']);
            end
            if (V2_check~=V2)
               warning([header1{2},' from ',load_files1{i0},'.xlsx has fewer values than initially defined (',num2str(V2_check),' out of ',num2str(V2),')']);
            end
%           %%% Changed technique from making 0,1 matrix of values to carrying data directly           
%             Int1 = zeros(V1,V2);                                    % Initialize matrix
%             for i1=1:V1
%                 for i2=1:V2
%                     for i3=1:M0
%                         if strcmp(Batch_header.(header1{2}).val{i2},raw1{i3,2})     % Quicker version of using an AND statement
%                             if strcmp(Batch_header.(header1{1}).val{i1},raw1{i3,1})
%                                 Int1(i1,i2) = 1; 
%                             end
%                         end      
%         % LEGACY        eval(sprintf('if (strcmp(Batch_header.%s.val{%d},raw1{%d,1}) && strcmp(Batch_header.%s.val{%d},raw1{%d,2}) ), Int1(%d,%d) = 1; end',header1{1},i1,i3,header1{2},i2,i3,i1,i2))
%         % LEGACY        if (strcmp(Batch_header.elec_rate_instance.val{i0},raw1{i2,1}) && strcmp(Batch_header.load_prof_instance.val{i1},raw1{i2,2}) ), Int1(i0,i1) = 1; end
%                     end
%                 end
%             end

            %%% Use Batch.header to convert text to integer values
            
            Col1 = zeros(M0,1); % Initialize
            for i1=1:V1         % Convert text to values based on order from Batch_header
                Col1(strcmp(raw1(:,1),Batch_header.(header1{1}).val{i1}))=i1;
            end
            Col2 = zeros(M0,1); % Initialize
            for i2=1:V2         % Convert text to values based on order from Batch_header
                Col2(strcmp(raw1(:,2),Batch_header.(header1{2}).val{i2}))=i2;
            end

            Batch_header.(header1{1}).(header1{2}) = [Col1,Col2];   % Include field relationship
            Batch_header.(header1{2}).(header1{1}) = [Col2,Col1];   % Include reciprocal field relationship
        % LEGACY          Batch_header.elec_rate_instance.load_prof_instance = Int1;
        disp(['  ',load_files1{i0},'.xlsx Completed'])
        clear header1 raw1 Int1 M0 V1 V2 i1 i2 i3
        end
%         save([indir,'\Batch_header.m'],'Batch_header')
end