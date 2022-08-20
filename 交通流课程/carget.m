function [v1]=carget()
v_max=5;
a=0.4617;%投放概率
if (rand(1))<(a)%概率小于a发车
    v1=v_max;   
else
    v1=0;
end
end
