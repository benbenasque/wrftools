function [ forecast_time_idx] =find_closest_forecast(Namelist,time_serie_nwp_forecast)
% Summary of this function goes here
%   Detailed explanation goes here
now=datenum(Namelist{5}.Analog.now,Namelist{1}.datstr_turbine_input_format)
forecast_time_idx=find(now==datenum(time_serie_nwp_forecast{1,1},Namelist{1}.datstr_general_format))
end

