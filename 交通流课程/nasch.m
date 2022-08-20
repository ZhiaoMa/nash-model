%���ò���
vmax = 5;
p = 0.3;
road_length = 1000;
simulation_steps = 10000;
render_on = 0;
pause_on = 0;
delay_on = 0;
delay_length = 0.01; %10 FPS
road = zeros(1,road_length); %���õ�·Ԫ������
road_next = road;
velocities = zeros(1,road_length); %�����ٶȾ���
velocities_next = velocities;
%������
num_samples = 200;
samples = zeros(2,num_samples); %�������ܶȵ��Ӧ����
density_step = 1/num_samples;%�ܶȲ���
history = zeros(simulation_steps, road_length);%��¼���з���ʱ�䲽�ĵ�·���
velocity_history = zeros(simulation_steps, road_length);%��¼���з���ʱ�䲽���ٶ����
figure
for g=1:num_samples%��ʱ�շֲ�ͼʱ�����ó�����Ҫ���ܶȣ�������ͼʱ���ó�num_samples
%��·״̬����ʼ����״̬
road = zeros(1,road_length);%���һ�ּ�������³�ʼ����·
road_next = road;
density = g/num_samples;
car=density*road_length;
%������䳵��
rdm=randperm(road_length);
z=rdm(1:car);
for i=1:car
j=z(i);
if j==0
road(j)=0;
else
road(j)=1;
end
end
if render_on
imshow(road);
drawnow
end
%��ʼ����
for i=1:simulation_steps
history(i, :) = road;
velocity_history(i,:) = velocities;
%--------------------�ٶȸ���------------------------%
for j=1:road_length
if road(j) == 1
distance = 0;
%��������پ���
bf = 0;
for k=1:vmax
distance = k;
if j+k <= road_length %�����Ա߽�
index = j+k;
else
index = j+k-road_length; %�����Ա߽�
end
if road(index) == 1 
bf = 1;%�г�
end
if bf == 1, break, end
end
if velocities(j) < vmax %����
velocities(j) = min(velocities(j) + 1,vmax);
end
if (velocities(j) > distance - 1) && bf == 1 %����
velocities(j) = distance - 1;
end
if rand < p && velocities(j) > 0 %�������
velocities(j) = max(velocities(j) - 1,0);
end
end
end
%--------------------λ�ø���-------------------------------%
for j=1:road_length
if road(j) ==1
if j+velocities(j) <= road_length
index = j+velocities(j);
else
index = j+velocities(j) - road_length; %�����Ա߽�
end
%��ײ���
if road_next(index) == 1
disp('Collision detected')
end
road_next(index) = 1;
velocities_next(index) = velocities(j);
end
end
velocities = velocities_next;
road = road_next;
road_next = zeros(1,road_length);
if render_on
imshow(road);
drawnow
end
if pause_on
pause
end
if delay_on
pause(delay_length)
end
end
%��¼ÿ�β������ٶȡ���������
velocity_history = velocity_history.*history;
samples(:,g) = [mean(history(:))
(sum(velocity_history(:))/sum(history(:)))*mean(history(:))];%��¼�ܶȣ�����
disp('Sample step:')
g
end
%���ƻ���ͼ
scatter(samples(1,:), samples(2,:),'d');%1Ϊ�ܶȺ����꣬2Ϊ����������
axis([0 1 0 1]);
xlabel('Density')
ylabel('Flow')
title('Nagel Schreckenberg Flow-density Curve')
%����ʱ��ͼ
space=history+velocity_history;
for i=0:6
space(find(space==i))=i-1;
end
timespace=num2str(space);
for m=simulation_steps-499:simulation_steps
timespace2=strrep(timespace(m,:),'-1',' ~');
disp(timespace2);%��ʾͼ��
end
pause