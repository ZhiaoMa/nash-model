function result = count_factors(n)
count=0;
for i = 1 : n
if mod(n,i)==0
    count=count+1;
end
end
result=count;
end

