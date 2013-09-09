function [ data ] = get_turbine_data_2( Namelist )
%GET_TURBINE_DATA_2 Summary of this function goes here
%   Detailed explanation goes here
% Summary of this function goes here
%   Detailed explanation goes here

% as observation may be in several files teck
[ m n]= size(Namelist{1}.turbine_data_file);
for i=1:m
    fid = fopen(Namelist{1}.turbine_data_file(i,:))
    InputText=textscan(fid,'%s',1,'delimiter','\n'); % read 1 header line 
    % holds infoabout the data fields
    dummy= regexp(InputText{1,1}, '\;', 'split');
    Field_headers=dummy{1,1}
    format='%u %u %s %u %s %s %s %s %s %s %s %s %u %s %s %s %s %u %n %n %n %n %n %n %n %n %n %n %n %n %n'
    %barrow 'C:\Users\jnini\Documents\MATLAB\work\Sand_box_model\Data\Observations\Barrow_obs_version_2.csv'
    %format='%u %u %s %u %s %s %s %s %s %s %s %s %u %s %s %s %s %u %n %n %n %n %%n %n %n' 
    [data_temp{i} position]=textscan(fid,format,'delimiter',';');
    [mi ni]=size(data_temp{i});
    
end % for
% concatenate turbine inputfiles 
for i=1:ni
    data{1,i}=cat(1,data_temp{1}{1,i},data_temp{2}{1,i},data_temp{3}{1,i},data_temp{4}{1,i},data_temp{5}{1,i},data_temp{6}{1,i},data_temp{7}{1,i})
end
    for i=1:ni
    data{2,i}=Field_headers{1,i};
    end 
 fclose('all')  
%end 

end


