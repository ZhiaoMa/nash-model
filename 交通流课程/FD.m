function FD(X,Y)
n=length(X);
X1=X;
Y1=Y;
for i=1:n-1
    x=X1(i):0.01:X1(i+1);
    y=Y1(i)*(x-X1(i+1))/(X1(i)-X1(i+1))+Y1(i+1)*(x-X1(i))/(X1(i+1)-X1(i));
    plot(X,Y,'*',X1,Y1,'r');
    hold on
end
xlabel('x');
ylabel('y');
syms x;
for i=1:n-1
    y=Y1(i)*(x-X1(i+1))/(X1(i)-X1(i+1))+Y1(i+1)*(x-X1(i))/(X1(i+1)-X1(i))
end