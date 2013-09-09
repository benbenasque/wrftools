function [ succes ] = do_turbine_by_turbine_stat( Namelist )
%DO_TURBINE_BY_TURBINE_STAT Summary of this function goes here
%   Detailed explanation goes here
figure
data_dir=[Namelist{1}.workspace_data_dir,'\experiments\',Namelist{11}.experiment,'\']
            load([data_dir,'turbine_time_series_for_nr_analogs_',num2str(8)])
            
            [m n]=size(turbine_time_series)
            for turbine_counter=1:n
                idx_not_missing=find(turbine_time_series(1,turbine_counter).data{2,15}~=Namelist{1}.missing_value);
                obs{turbine_counter}=turbine_time_series(1,turbine_counter).data{2,15}(idx_not_missing);
                model_ANALOG{turbine_counter}=turbine_time_series(1,turbine_counter).data{2,2}(idx_not_missing); 
                [rmse(turbine_counter) bias(turbine_counter) crmse(turbine_counter)] = RMSEdecomp_all(obs{turbine_counter}, model_ANALOG{turbine_counter})
                [nrmse(turbine_counter) nbias(turbine_counter) ncrmse(turbine_counter)] = RMSEdecomp_all(obs{turbine_counter}/Namelist{10}.rated_capasity_kw, model_ANALOG{turbine_counter}/Namelist{10}.rated_capasity_kw)
                nmae(turbine_counter) = mean(abs(obs{turbine_counter}/Namelist{10}.rated_capasity_kw- model_ANALOG{turbine_counter}/Namelist{10}.rated_capasity_kw))
                xtick_labels{turbine_counter}=num2str(turbine_time_series(1,turbine_counter).id(1));
            end
            
barmtx(1,:)=nrmse;barmtx(2,:)=ncrmse;barmtx(3,:)=nbias;barmtx(4,:)=nmae;

bar(barmtx');colormap('gray');set(gca,'xticklabel',xtick_labels,'fontsize',Namelist{7}.fontsize);grid on
xlabel('Turbine id','fontsize',Namelist{7}.fontsize)
ylabel('Normalized power','fontsize',Namelist{7}.fontsize)
legend({'NRMSE','NCRMSE','NBIAS','NMAE'})
succes='true'
end

