function [ power_forecast ] = get_power_from_analog(dates_analog,Namelist,good_turbine_data, num_obs_clean_power,num_obs_nacelle_winds,turbine_counter,forecast_vector,time_serie_nwp_forecast);

%get_power_from_analog(dates_analog,Namelist,good_turbine_data,num_obs_dates,turbine_counter,forecast_vector)
%get_power_from_analog(dates_analog,Namelist,good_turbine_data, num_obs_clean_power,num_obs_nacelle_winds,turbine_counter,forecast_vector);
%GET_POWER_FROM_ANALOG Summary of this function goes here
%   Detailed explanation goes here
% do stuff if numdates =999

for i=1:length(Namelist{5}.Analog.lead_times)

 switch 1
    case Namelist{6}.Analog_to_power
        % loop trough all lead times 
            num_analog_dates=datenum(dates_analog.lead(i).dates,Namelist{1}.datstr_general_format);
            %datenum(datestr(datenum(dates_analog.lead(i).dates,Namelist{1}.datstr_general_format),'yyyy-mm-dd HH:MM'),'yyyy-mm-dd HH:MM');
            for j=1:Namelist{5}.Analog.number_of_analogs_search_for % loop trough all analogs
                dummy=find(num_analog_dates(j)==num_obs_clean_power);
                if not(isempty(dummy))
                    idx_power_obs(i,j)=int64(dummy(1));
                else
                    idx_power_obs(i,j)=int64(0);
                end
            end
    % now get the forecast attributes on the lead time 
            [power_forecast(i).power_distribution power_forecast(i).weighted_power_distribution power_forecast(i).percentiles_from_power_distribution power_forecast(i).deterministic_power_forecast power_forecast(i).Analog_weights]...
            =get_power_distribution(good_turbine_data,idx_power_obs(i,:),Namelist,dates_analog.lead(i).weights,num_obs_clean_power,Namelist{5}.Analog.lead_times(i));
           
     case Namelist{6}.Analog_to_turbine_wind
             lead=i; % option to speed up things within this function by sending all the num_dates % now changed 05/07 2012
                [wind_forecast(i).wind_distribution wind_forecast(i).weighted_wind_distribution ...
                 wind_forecast(i).percentiles_from_wind_distribution...
                 wind_forecast(i).deterministic_wind_forecast wind_forecast(i).Analog_weights]...
                 =get_wind_distribution_from_turbine(good_turbine_data(1,turbine_counter).wind_all{1,2},...
                 good_turbine_data(1,turbine_counter).wind_all{1,4},dates_analog.lead(lead).dates(1,turbine_counter),...
                 lead,Namelist,dates_analog.lead(i).weights,num_obs_nacelle_winds);
                 wind_forecast(i).valid_dates=forecast_vector.var_data{2,1}(i,:);
            [power_forecast(i).power_distribution power_forecast(i).weighted_power_distribution power_forecast(i).deterministic_power_forecast ...
             power_forecast(i).percentiles_from_power_distribution ]...      
            =get_power_from_wind_forecast( forecast_vector,time_serie_nwp_forecast,wind_forecast(i),Namelist,good_turbine_data(1,turbine_counter).power_production, Namelist{5}.Analog.lead_times(i));
             power_forecast(i).valid_dates=forecast_vector.var_data{2,1}(i,:);
             power_forecast(i).wind.forecast=mean(wind_forecast(i).wind_distribution);
             power_forecast(i).wind.distribution=wind_forecast(i).wind_distribution;
     
     case Namelist{10}.nwp_to_power_forecast_method==2
         lead=i; % option to speed up things within this function by sending all the num_dates % now changed 05/07 2012
        [power_forecast(i).power_distribution power_forecast(i).weighted_power_distribution power_forecast(i).percentiles_from_power_distribution power_forecast(i).deterministic_power_forecast power_forecast(i).Analog_weights]...
        =get_power_distribution_from_turbine...
        (good_turbine_data(1,turbine_counter).power_production{1,2},...
        good_turbine_data(1,turbine_counter).power_production{1,3},...
        dates_analog.lead(lead).dates(1,turbine_counter),lead,Namelist,dates_analog.lead(i).weights,num_obs_clean_power);
         power_forecast(i).valid_dates=forecast_vector.var_data{2,1}(i,:);
   
 end %Switch
    
end



end

