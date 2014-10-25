%K-means
%Use k-means to cluster the data(The Female Male database)
%In the test data, male:1, female:0
%Author: shuaijiang
%Email: zhaoshuaijiang8@gmail.com
%date: 20141024

clear all;

%%%%% Setting %%%%%
k  = 2;  %the number of the cluster
test_num = 35;

test_file  = 'test0.txt';
test_data  = zeros(test_num,3);
distance   = zeros(test_num,k);
test_label = zeros(test_num,1);
center     = zeros(k,3) ;
center_mean     = zeros(k,2) ;
center_new     = zeros(k,3) ;
%%%%% Setting %%%%%

%%%%% Load the Test Data %%%%%
[fid,message] = fopen(test_file,'r');
if fid>0
    test_data   = fscanf(fid,'%g',[3,50])';
else
    disp(message);
    return;
end
%%%%% Load the Test Data %%%%%

%%%%% K-means %%%%%
center_num = 0;
while(center_num<k)
    index =  randi(test_num,1,k);
    index_unique = unique(index);
    center_num = size(index_unique,2);
end
center = test_data(index_unique,:);

count = 0;
while(1)
    %Compute each sample to which center belong
    for i=1:test_num
        for j=1:k
            distance(i,j) = sqrt(sum((test_data(i,1:2)-center(j,1:2)).^2));
        end
        [dis,idx] = min(distance(i,:));
        test_label(i) = idx;
    end
    %Choose new center
    for i=1:k
        index = find(test_label==i);
        center_mean(i,1:2) = mean(test_data(index,1:2));
        first_index=index(1);
        min_value = sqrt(sum((test_data(first_index,1:2)-center_mean(i,1:2)).^2));
        center_new(i,:) = test_data(first_index,:);
        for m=1:length(index)
            n=index(m);
            value = sqrt(sum((test_data(n,1:2)-center_mean(i,1:2)).^2));
            if(value<min_value)
                min_value = value;
                center_new(i,:) = test_data(n,:);
            end
        end
    end
    %Decide wheather stop while
    same = 0;
    for i=1:k
        if(center(i,:) == center_new(i,:))
            same = same +1;
        end
    end
    count = count + 1;
    if(same == k || count>200)
        fprintf('count=%d\n',count);
        break;
    end
end
%%%%% Test: Make the Decision %%%%%

for i=1:k
    male_count   = 0;
    female_count = 0;
    index = find(test_label==i);
    for m=1:length(index)
        n = index(m);
        if(test_data(n,3) == 0)
            female_count = female_count + 1;
        else
            male_count = male_count + 1;
        end
        %fprintf('center_index=%d,gender=%g\n',i,test_data(n,3));
    end
    if(male_count > female_count)
        fprintf('Cluster:male,Test_male=%d,Test_female=%d\n',male_count,female_count);
    else
        fprintf('Cluster:female,Test_male=%d,Test_female=%d\n',male_count,female_count);
    end
end

