function [ data updated] =update_timeseries(data,lates_init_time,Namelist)
% append the lastest nwp run to time series 
switch 1
    
    case strcmp(Namelist{4}.nwp_model{1},'WRF')
              existing_num_init_times=datenum(data{1,1},Namelist{1,1}.datstr_general_format);
              ddtg=datestr(datenum(lates_init_time),'yyyymmddHH')
              dir_name=['\TimeSeries_',datestr(datenum(lates_init_time),'yyyymmddHH'),'\']
              domaine_group=['_','d0',num2str(Namelist{4}.nwp_model_domain),'_']
              file_name=strcat(Namelist{1}.forcast_data_timerseries,dir_name,Namelist{2}.location{1},domaine_group,ddtg(1:length(ddtg)),'.dat')
              fileInfo = dir(file_name);
        if not(isempty(fileInfo))
            fileSize = fileInfo.bytes; % make sure something is in the file 
        end
        fid = fopen(file_name)
        
        if not(fid==-1) & not(fileSize==0)
            format='%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s'
            [headers]=textscan(fid,format,1,'HeaderLines',3); % to get whole data set remove 100 when done testing 
            format='%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f'
            [data_tempo position]=textscan(fid,format); % to get whole data set remove 100 when done testing 
             % First check if data allready there
             new_num_init_times=datenum(data_tempo{1},Namelist{1}.datstr_WRF_input_format)
            idx=find(new_num_init_times(1)==existing_num_init_times)
            
     if not(isempty(idx))
            data{1,1}(idx,:)=[] 
            data{1,2}(idx,:)=[]
            data{1,3}(idx,:)=[]
            data{1,4}(idx,:)=[]
            data{1,5}(idx,:)=[]
            data{1,6}(idx,:)=[]
            data{1,7}(idx,:)=[]
            data{1,8}(idx,:)=[]
            data{1,9}(idx,:)=[]
            data{1,10}(idx,:)=[]
            data{1,11}(idx,:)=[]
            data{1,12}(idx,:)=[]
            data{1,13}(idx,:)=[]
            data{1,14}(idx,:)=[]
            data{1,15}(idx,:)=[]
            data{1,16}(idx,:)=[]
            data{1,17}(idx,:)=[]
            data{1,18}(idx,:)=[]
            data{1,19}(idx,:)=[]
            data{1,20}(idx,:)=[]
            data{1,21}(idx,:)=[]
            data{1,22}(idx,:)=[]
            data{1,23}(idx,:)=[]
            data{1,24}(idx,:)=[]
            data{1,25}(idx,:)=[]
            data{1,26}(idx,:)=[]
            data{1,27}(idx,:)=[]
            data{1,28}(idx,:)=[]
            data{1,29}(idx,:)=[]
            data{1,30}(idx,:)=[]
            data{1,31}(idx,:)=[]
            data{1,32}(idx,:)=[]
            data{1,33}(idx,:)=[]
            data{1,34}(idx,:)=[]
            data{1,35}(idx,:)=[]
            data{1,36}(idx,:)=[]
            data{1,37}(idx,:)=[]
            data{1,38}(idx,:)=[]
            data{1,39}(idx,:)=[]
            data{1,40}(idx,:)=[]
            data{1,41}(idx,:)=[]
     end 
            %first make sure that data looks like eta     
            tempo{1}= datestr(datenum(data_tempo{1},Namelist{1}.datstr_WRF_input_format),Namelist{1}.datstr_general_format);
            tempo{2,1}=headers(1);
            tempo{1,2}= datestr(datenum(data_tempo{2},Namelist{1}.datstr_WRF_input_format),Namelist{1}.datstr_general_format);
            tempo{2,2}=headers(2);
            tempo{1,3}= data_tempo{6}; %t2
            tempo{2,3}=headers(6);
            tempo{1,4}= data_tempo{6}; %tmp0_30mb
            tempo{2,4}=headers(6);
            tempo{1,5}= data_tempo{8}; %rh2 m
            tempo{2,5}=headers(8);
            tempo{1,6}= data_tempo{3}; %wspd 10
            tempo{2,6}=headers(3);
            tempo{1,7}= data_tempo{4}; %wdir
            tempo{2,7}=headers(4);
            tempo{1,8}= data_tempo{3}; %wspd 0_30_mb Not existing
            tempo{2,8}=headers(3);
            tempo{1,9}= data_tempo{4}; %wspd 0_30_mb Not existing
            tempo{2,9}=headers(4);
            tempo{1,10}= data_tempo{5}; %mslp
            tempo{2,10}=headers(5);
            tempo{1,11}= data_tempo{11}; % ustar
            tempo{2,11}=headers(11);
            tempo{1,12}= data_tempo{13}; % Rho 10m
            tempo{2,12}=headers(13);
            tempo{1,13}= data_tempo{13}; % rho 0_30mb
            tempo{2,13}=headers(13);
            tempo{1,14}=get_lead_time_2( Namelist,tempo);
            tempo{2,14}='Lead time'        
            
            tempo{2,15}=headers(15);
            tempo{1,15}=data_tempo{15};
            tempo{2,16}=headers(16);
            tempo{1,16}= data_tempo{16}; %t2
            tempo{2,17}=headers(17);
            tempo{1,17}= data_tempo{17}; %tmp0_30mb
            tempo{2,18}=headers(18);
            tempo{1,18}= data_tempo{18}; %rh2 m
            tempo{2,19}=headers(19);
            tempo{1,19}= data_tempo{19}; %wspd 10
            tempo{2,20}=headers(20);
            tempo{1,20}= data_tempo{20}; %wdir
            tempo{2,21}=headers(21);
            tempo{1,21}= data_tempo{21}; %wspd 0_30_mb Not existing
            tempo{2,22}=headers(22);
            tempo{1,22}= data_tempo{22}; %wspd 0_30_mb Not existing
            tempo{2,23}=headers(23);
            tempo{1,23}= data_tempo{23}; %mslp
            tempo{2,24}=headers(24);
            tempo{1,24}= data_tempo{24}; % ustar
            tempo{2,25}=headers(25);
            tempo{1,25}= data_tempo{25}; % Rho 10m
            tempo{2,26}=headers(26);
            tempo{1,26}= data_tempo{26}; % rho 0_30mb
            tempo{2,27}=headers(27);
            tempo{1,27}= data_tempo{27}; %t2
            tempo{2,28}=headers(28);
            tempo{1,28}= data_tempo{28}; %tmp0_30mb
            tempo{2,29}=headers(29);
            tempo{1,29}= data_tempo{29}; %rh2 m
            tempo{2,30}=headers(30);
            tempo{1,30}= data_tempo{30}; %wspd 10
            tempo{2,31}=headers(31);
            tempo{1,31}= data_tempo{31}; %wdir
            tempo{2,32}=headers(32);
            tempo{1,32}= data_tempo{32}; %wspd 0_30_mb Not existing
            tempo{2,33}=headers(33);
            tempo{1,33}= data_tempo{33}; %wspd 0_30_mb Not existing
            tempo{2,34}=headers(34);
            tempo{1,34}= data_tempo{34}; %mslp
            tempo{2,35}=headers(35);
            tempo{1,35}= data_tempo{35}; % ustar
            tempo{2,36}=headers(36);
            tempo{1,36}= data_tempo{36}; % Rho 10m
            tempo{2,37}=headers(37);
            tempo{1,37}= data_tempo{37}; % rho 0_30mb
            tempo{2,38}=headers(38);
            tempo{1,38}= data_tempo{38}; % rho 0_30mb
            tempo{2,39}=headers(39);
            tempo{1,39}= data_tempo{39}; % rho 0_30mb
            tempo{2,40}=headers(40);
            tempo{1,40}= data_tempo{40}; % rho 0_30mb
            tempo{2,41}=headers(41);
            tempo{1,41}= data_tempo{41}; % rho 0_30mb
            
            data{1,1}= vertcat(data{1,1},tempo{1,1}); 
            data{1,2}=vertcat(data{1,2},tempo{1,2});
            data{1,3}=vertcat(data{1,3},tempo{1,3});
            data{1,4}=vertcat(data{1,4},tempo{1,4});
            data{1,5}=vertcat(data{1,5},tempo{1,5});
            data{1,6}=vertcat(data{1,6},tempo{1,6});
            data{1,7}=vertcat(data{1,7},tempo{1,7});
            data{1,8}=vertcat(data{1,8},tempo{1,8});
            data{1,9}=vertcat(data{1,9},tempo{1,9});
            data{1,10}=vertcat(data{1,10},tempo{1,10});
            data{1,11}=vertcat(data{1,11},tempo{1,11});
            data{1,12}=vertcat(data{1,12},tempo{1,12});
            data{1,13}=vertcat(data{1,13},tempo{1,13});
            data{1,14}=vertcat(data{1,14},tempo{1,14});
            data{1,15}= vertcat(data{1,15},tempo{1,15}); 
            data{1,16}=vertcat(data{1,16},tempo{1,16});
            data{1,17}=vertcat(data{1,17},tempo{1,17});
            data{1,18}=vertcat(data{1,18},tempo{1,18});
            data{1,19}=vertcat(data{1,19},tempo{1,19});
            data{1,20}=vertcat(data{1,20},tempo{1,20});
            data{1,21}=vertcat(data{1,21},tempo{1,21});
            data{1,22}=vertcat(data{1,22},tempo{1,22});
            data{1,23}=vertcat(data{1,23},tempo{1,23});
            data{1,24}=vertcat(data{1,24},tempo{1,24});
            data{1,25}=vertcat(data{1,25},tempo{1,25});
            data{1,26}=vertcat(data{1,26},tempo{1,26});
            data{1,27}=vertcat(data{1,27},tempo{1,27});
            data{1,28}=vertcat(data{1,28},tempo{1,28});

            data{1,29}= vertcat(data{1,29},tempo{1,29}); 
            data{1,30}=vertcat(data{1,30},tempo{1,30});
            data{1,31}=vertcat(data{1,31},tempo{1,31});
            data{1,32}=vertcat(data{1,32},tempo{1,32});
            data{1,33}=vertcat(data{1,33},tempo{1,33});
            data{1,34}=vertcat(data{1,34},tempo{1,34});
            data{1,35}=vertcat(data{1,35},tempo{1,35});
            data{1,36}=vertcat(data{1,36},tempo{1,36});
            data{1,37}=vertcat(data{1,37},tempo{1,37});
            data{1,38}=vertcat(data{1,38},tempo{1,38});
            data{1,39}=vertcat(data{1,39},tempo{1,39});
            data{1,40}=vertcat(data{1,40},tempo{1,40});
            data{1,41}=vertcat(data{1,41},tempo{1,41});
            updated=1;
            fclose(fid);
        else
            Disp(['forecast file:',file_name,' not yet available'])
            updated=0;
        end
        
            
           
end

