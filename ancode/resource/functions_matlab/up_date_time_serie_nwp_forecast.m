function [ time_serie_nwp_forecast ] = up_date_time_serie_nwp_forecast(Namelist,time_serie_nwp_forecast)
%UP_DATE_TIME_SERIE_NWP_FORECAST Summary of this function goes here
%   Detailed explanation goes here
% updates the historical time serie of nwp forecast 
switch 1
    case strcmp(Namelist{4}.nwp_model{1},'ETA')
    time_serie_nwp_forecast_new=get_time_series_ETAforecast_for_update(Namelist);
    for i=1:length(time_serie_nwp_forecast_new)
        time_serie_nwp_forecast{1,i}=vertcat(time_serie_nwp_forecast{1,i}, time_serie_nwp_forecast_new{1,i});
        time_serie_nwp_forecast{2,i}=time_serie_nwp_forecast_new{2,i}
    end
        
    case strcmp(Namelist{4}.nwp_model{1},'WRF')
end 

end

