function []=plot_time_space()
load('NaSch_date.mat');
for time=1:1:1000
    tool = memory(time,:);%��ȡÿ��ʱ�ղ��ٶ�����
    tool(tool>=0)=time;%���ٶȵĳ����
    tool(isnan(tool))=-100;%�ճ��޳�
    plot(1:L,tool,'k*','Markersize',1);hold on
end
xlabel('�ռ�','Fontsize',12);
ylabel('ʱ��','Fontsize',12);
set (gcf,'Position',[200,300,500,300]);
ylim([0 1000]);   %��������������
end