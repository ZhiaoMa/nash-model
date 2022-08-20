%设置参数
vmax = 5;
p = 0.3;
road_length = 1000;
simulation_steps = 10000;
render_on = 0;
pause_on = 0;
delay_on = 0;
delay_length = 0.01; %10 FPS
road = zeros(1,road_length); %设置道路元胞矩阵
road_next = road;
velocities = zeros(1,road_length); %设置速度矩阵
velocities_next = velocities;
%采样点
num_samples = 200;
samples = zeros(2,num_samples); %流量、密度点对应矩阵
density_step = 1/num_samples;%密度步长
history = zeros(simulation_steps, road_length);%记录所有仿真时间步的道路情况
velocity_history = zeros(simulation_steps, road_length);%记录所有仿真时间步的速度情况
figure
for g=1:num_samples%画时空分布图时候设置成所需要的密度，画基本图时设置成num_samples
%道路状态，初始车辆状态
road = zeros(1,road_length);%完成一轮计算后重新初始化道路
road_next = road;
density = g/num_samples;
car=density*road_length;
%随机分配车辆
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
%开始仿真
for i=1:simulation_steps
history(i, :) = road;
velocity_history(i,:) = velocities;
%--------------------速度更新------------------------%
for j=1:road_length
if road(j) == 1
distance = 0;
%检测最大加速距离
bf = 0;
for k=1:vmax
distance = k;
if j+k <= road_length %周期性边界
index = j+k;
else
index = j+k-road_length; %周期性边界
end
if road(index) == 1 
bf = 1;%有车
end
if bf == 1, break, end
end
if velocities(j) < vmax %加速
velocities(j) = min(velocities(j) + 1,vmax);
end
if (velocities(j) > distance - 1) && bf == 1 %减速
velocities(j) = distance - 1;
end
if rand < p && velocities(j) > 0 %随机慢化
velocities(j) = max(velocities(j) - 1,0);
end
end
end
%--------------------位置更新-------------------------------%
for j=1:road_length
if road(j) ==1
if j+velocities(j) <= road_length
index = j+velocities(j);
else
index = j+velocities(j) - road_length; %周期性边界
end
%碰撞检测
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
%记录每次采样的速度、流量数据
velocity_history = velocity_history.*history;
samples(:,g) = [mean(history(:))
(sum(velocity_history(:))/sum(history(:)))*mean(history(:))];%记录密度，流量
disp('Sample step:')
g
end
%绘制基本图
scatter(samples(1,:), samples(2,:),'d');%1为密度横坐标，2为流量纵坐标
axis([0 1 0 1]);
xlabel('Density')
ylabel('Flow')
title('Nagel Schreckenberg Flow-density Curve')
%绘制时空图
space=history+velocity_history;
for i=0:6
space(find(space==i))=i-1;
end
timespace=num2str(space);
for m=simulation_steps-499:simulation_steps
timespace2=strrep(timespace(m,:),'-1',' ~');
disp(timespace2);%显示图形
end
pause