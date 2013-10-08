function [ TRIUMF ] =Make_EPS_time_series_turbine_vice_w2p(Namelist)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    in_file=[Namelist{1}.ecmwf_eps_dir_in,'/eps_sprogoe_time_series_turbine_wice']
    [Init_time,Valid_time,wspd1,Uinit_id1,wspd2,Uinit_id2,wspd3,Uinit_id3,wspd4,Uinit_id4,...
     wspd5,Uinit_id5,wspd6,Uinit_id6,wspd7,Uinit_id7,Ensemble_nr,Lead_hour ]...
     =textread(in_file, '%s%s%f%u%f%u%f%u%f%u%f%u%f%u%f%u%u%u','whitespace',' ','headerlines',3);
    header_lines=textread(in_file, '%s',35);
% now the data is here now we look at each turbine and convert the
% predicted wind speed to prvious produced power for than wind speed
% first get all the data needed and delte what is not needed 

[good_turbine_data time_serie_nwp_forecast num_obs_dates clean_turbine_data]=load_data(Namelist)

clear time_serie_nwp_forecast;clear num_obs_dates;clear clean_turbine_data 

% get verififing power observations 
%load('C:\Users\jnini\MATLAB\work\AnEn\data\testing\matlab.mat') 
[ Namelist ]=set_Namelist_N30471( );
   [n]=Namelist{1}.number_of_turbines_in_park;
   date_num_ecmwf=datenum(char(Valid_time),'yyyymmddHH');
   nr_ecmwf=length(date_num_ecmwf);
   Power_obs(1:nr_ecmwf,1:n)=Namelist{1}.missing_value;
    
% Finds observations that verified when forecast was valid 
use_saved_work_spce=1
if use_saved_work_spce
    load('C:\Users\jnini\MATLAB\work\AnEn\data\testing\obs.mat') 
else
    for i=1:n
       date_num_turbine=datenum(good_turbine_data(1,i).power_production{1,2},'dd-mm-yyyy HH:MM:SS');
       nr_verifing_obs=length(date_num_turbine);
        for j=1:nr_verifing_obs
            verif_obs_idx=find(abs(date_num_turbine(j)-date_num_ecmwf)<Namelist{1}.minutes_in_fraction_of_a_day);
            Power_obs_verif(i,j)=good_turbine_data(1,i).power_production{1,3}(j);
            if not(isempty(verif_obs_idx))
                Power_obs(verif_obs_idx,i)=Power_obs_verif(i,j);
            end
            if mod(j,1000)==0
                display(['% obs match:', sprintf('%04.2f',(j/nr_verifing_obs)*100),' turbine nr:',sprintf('%02.1f',i)])
            end
        end 
    end

end
% do the wind to power convertion and generate output string lines  
% headline in output files =
     seperator=' '
        out_string_header_1= [header_lines{1},seperator,header_lines{2},seperator,header_lines{3},seperator,header_lines{4},seperator,header_lines{5},seperator,header_lines{6},seperator,header_lines{7},seperator,header_lines{8},seperator,header_lines{9},seperator,header_lines{10},seperator,header_lines{11},seperator,header_lines{12}]
        out_string_header_2=[header_lines{1},seperator,'Missing value=-999',seperator,' Standard bilinear interpolation from grid to turbine position' ]
        out_string_header_3=['Init (utc)',seperator,'Valid (utc)',seperator,'Ecmwf_wspd_1 (m/s)',seperator,'Power_pred_1 (kw)',seperator,'Unit_id_1',seperator,'Power_obs_1' ...
        ,seperator,'Ecmwf_wspd_2 (m/s)',seperator,'Power_pred_2 (kw)',seperator,'Unit_id_2',seperator,'Power_obs_2 (kw)' ...
        ,seperator,'Ecmwf_wspd_3 (m/s)',seperator,'Power_pred_3 (kw)',seperator,'Unit_id_3',seperator,'Power_obs_3 (kw)' ...
        ,seperator,'Ecmwf_wspd_4 (m/s)',seperator,'Power_pred_4 (kw)',seperator,'Unit_id_4',seperator,'Power_obs_4 (kw)' ...
        ,seperator,'Ecmwf_wspd_5 (m/s)',seperator,'Power_pred_5 (kw)',seperator,'Unit_id_5',seperator,'Power_obs_5 (kw)' ...
        ,seperator,'Ecmwf_wspd_6 (m/s)',seperator,'Power_pred_6 (kw)',seperator,'Unit_id_6',seperator,'Power_obs_6 (kw)' ...
        ,seperator,'Ecmwf_wspd_7 (m/s)',seperator,'Power_pred_7 (kw)',seperator,'Unit_id_7',seperator,'Power_obs_7 (kw)' ...
        ,seperator,'Ensemble_member',seperator,'Lead_hour']
        
fout=[Namelist{1}.ecmwf_eps_dir_in,'\eps_sprogoe_time_series_and_power_obs_turbinvice.txt']
fid=fopen(fout,'w')
fid=fopen(fout,'w')

    fprintf(fid,'%s\n',out_string_header_1)
    fprintf(fid,'%s\n',out_string_header_2)
    fprintf(fid,'%s\n',out_string_header_3)
    
fct_wspd=[wspd1,wspd2,wspd3,wspd4,wspd5,wspd6,wspd7];
unit_id=[Uinit_id1(1) Uinit_id2(1) Uinit_id3(1) Uinit_id4(1) Uinit_id5(1) Uinit_id6(1) Uinit_id7(1) ]
 for j=1:length(fct_wspd);
     start_string=[Init_time{j},seperator,Valid_time{j}];
     end_string=[seperator sprintf('%03u',Ensemble_nr(j)),seperator,sprintf('%02u',Lead_hour(j))];
     for i=1:n % loop through all turbines and find maching nacelle wind speed and accociated power 
        [diff idx]=sort(abs(good_turbine_data(1,i).power_production{1,4}-fct_wspd(j,i)),'ascend');
        power_pred(j,i)=mean(good_turbine_data(1,i).power_production{1,3}(idx(1:Namelist{12}.use_nr_closest_power_observations)));
        temp_out_string(i,:)= [seperator,sprintf('%05.2f',fct_wspd(j,i)),seperator,sprintf('%07.2f',power_pred(j,i)),seperator,sprintf('%0.5u',unit_id(i)),seperator,sprintf('%07.2f',Power_obs(j,i))];
     end
         out_string=[start_string temp_out_string(1,:) temp_out_string(2,:) ...
         temp_out_string(3,:) temp_out_string(4,:) temp_out_string(5,:)...
         temp_out_string(6,:) temp_out_string(1,:) temp_out_string(7,:) end_string];
         % now concanate the strings and print the damm thing 
         fprintf(fid,'%s\n',out_string);
         clear out_string;clear temp_out_string
         if mod(j,1000)==0
             % print something for every 1000 lines written ti file 
            display(['% completed: ',sprintf('%05.2f',100*j/length(fct_wspd(:,i))),' %'])
         end 
end %for 

   fclose(fid)


end
