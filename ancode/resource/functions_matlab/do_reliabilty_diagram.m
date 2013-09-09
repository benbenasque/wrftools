function [ succes ] = do_reliabilty_diagram( Namelist,model_name,domaine,exp_name,analogs)
%DO_RELIABILTY_DIAGRAM Summary of this function goes here
%   Detailed explanation goes here
    file_path=[Namelist{1}.root_dir,'/data/workspace/',model_name,'/out/experiments/',exp_name]
    filename=strcat('/turbine_time_series_jan_may_',num2str(analogs))
    load([file_path,filename])
    if  Namelist{11}.Benchmarking_add_eps
        turbine_time_series=add_eps_time_series(Namelist,turbine_time_series)
    end 
% do concanation of all turbines 
    obs=[];model=[];model_ensembles=[];model_ensembles_variance=[];
    [m n]=size(turbine_time_series)
    event_treshold=0.5 % this means that the the event is power les than 50 % forecasted 
        for i=1:n
            % concanate loop
            good_idx{i}=find(turbine_time_series(1,i).data{2,15}~=Namelist{1}.missing_value );
            obs=vertcat(turbine_time_series(1,i).data{2,15}(good_idx{i})/Namelist{10}.rated_capasity_kw,obs);
            model=vertcat(turbine_time_series(1,i).data{2,2}(good_idx{i})/Namelist{10}.rated_capasity_kw,model);
            model_ensembles=vertcat(turbine_time_series(1,i).data{2,18}(good_idx{i},:)/Namelist{10}.rated_capasity_kw,model_ensembles);
        end
         % compute probs
         for i=1:length(obs)
             prob_event(i)=find_prob_event(model_ensembles(i,:),event_treshold);
         end 
         [sort_prob_event sort_idx]=sort(prob_event');
         sort_obs=obs(sort_idx);
         %bin the crap
         nr_bins=10;
         step=floor(length(obs)/nr_bins)
         bin_idx_vector=[1:step:length(obs)]
         
         for i=[1:1:length(bin_idx_vector)-1]
             avg_prob(i)=mean(sort_prob_event(bin_idx_vector(i):bin_idx_vector(i+1)))
             avg_obs_freq(i)=length(find(sort_obs(bin_idx_vector(i):bin_idx_vector(i+1))<event_treshold))/length([bin_idx_vector(i):bin_idx_vector(i+1)])
         end
         figure
         plot(avg_prob,avg_obs_freq,'-rs','linewidth',4);grid on
         set(gca,'fontsize',15)
         xlabel('Forecasted probabilities','fontsize',15)
         ylabel('Observed frequencies','fontsize',15)
         title('Reliabilty diagram - Model:ETA - Analogs:10','fontsize',20)
         hold on
         plot([0 0.9], [0 0.9], 'b','linewidth',4)
         axis square
         save_dir=[Namelist{1}.stat_plot_dir,'\prob-plots\Reliabilty_diagrams\']
            plot_filename=[model_name,'_Anlogs_',num2str(analogs),'_d_',num2str(domaine)]
                    if isdir(save_dir)
                       saveas(gcf,[save_dir plot_filename] ,'fig')
                       saveas(gcf,[save_dir plot_filename] ,'jpeg')

                    else
                        mkdir(save_dir)
                        saveas(gcf,[save_dir plot_filename] ,'fig')
                        saveas(gcf,[save_dir plot_filename] ,'jpeg')

                    end
%maximize
succes=true

end

