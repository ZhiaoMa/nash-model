function []=plot_time_space()
load('NaSch_date.mat');
for time=1:1:1000
    tool = memory(time,:);%提取每个时空步速度数据
    tool(tool>=0)=time;%有速度的车打点
    tool(isnan(tool))=-100;%空车剔除
    plot(1:L,tool,'k*','Markersize',1);hold on
end
xlabel('空间','Fontsize',12);
ylabel('时间','Fontsize',12);
set (gcf,'Position',[200,300,500,300]);
ylim([0 1000]);   %设置纵轴上下限
end