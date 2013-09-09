function [ clean_obs ] = get_turbine_data_2_cleaned(Namelist,turbine_data);
%GET_TURBINE_DATA_2_CLEANED Summary of this function goes here
%   Detailed explanation goes here
load([Namelist{1}.workspace_clean_obs_dir,'clean_power_obs_ref_2_4'])
[m n]=size(turbine_data);

for i=1:n
    clean_obs{2,i}=turbine_data(2,i)
end

clean_obs{1,1}=clean_power_obs.unitid;
clean_obs{1,2}=clean_power_obs.time_local;
clean_obs{1,3}=str2num(char(strrep(clean_power_obs.actual_avg_power, ',', '.')));
clean_obs{1,4}=clean_power_obs.run;
clean_obs{1,5}=clean_power_obs.deratepower;
clean_obs{1,6}=clean_power_obs.deraterun;
clean_obs{1,7}=clean_power_obs.psblepower;
clean_obs{1,8}=str2num(char(strrep(clean_power_obs.wspd, ',', '.')));
clean_obs{1,9}=str2num(char(strrep(clean_power_obs.wdir, ',', '.')));
clean_obs{1,11}=clean_power_obs.wdirrel;
clean_obs{1,12}=clean_power_obs.rungen1;
clean_obs{1,13}=clean_power_obs.rungen2;
clean_obs{1,14}=clean_power_obs.service;
clean_obs{1,15}=clean_power_obs.alarm;
clean_obs{1,16}=clean_power_obs.derateid;

