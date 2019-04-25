clc;
close all;
clear all;
p=10;
chtimgmin=zeros(288,288)+288;
chtimgmax=zeros(288,288);
notr=input('Enter no of traitors');
for i=1:notr
    traitor(i)=input('Enter Traitor');
end
ti=0
for k=1:p
    str = int2str(k);
    str = strcat('E:\M Tech\Semester 4\Hybrid Images\',str,'.bmp');
    a = imread(str);
    b=size(a); 
    c=size(find(traitor-k));
    sizc=c(2);
    if (notr~=sizc)
        chtimgmin=min(chtimgmin,double(a));
        chtimgmax=max(chtimgmax,double(a));
        ti=ti+1
    end
     b=size(a);
    for i=1:(b(1)*b(2))
        db(i,k)=a(i);
    end
end
chtimg=(chtimgmin+chtimgmax)/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Finding the mean of the images in the data base
meanvector=mean(db,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculating mean centered images
for l=1:p;
    meancenter(1:b(1)*b(2),l)=double(db(1:b(1)*b(2),l))-meanvector(1:b(1)*b(2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Finding eigen values and eigen vectors for the f matrix
f=meancenter'*meancenter;	
[V,D] = eig(f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Setting a theshold for the eigen values and eliminating the eigen values
%%less than threshold
f_eig_vec = [];
for i = 1 : size(V,2) 
    if( D(i,i)>1 )
        f_eig_vec = [f_eig_vec V(:,i)];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculating the eigen faces of the corresponding eigen values
Eigenfaces = meancenter * f_eig_vec;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%projecting the images in the database with the span of eigen faces
projectedImages = [];
for i = 1 : p
    temp = Eigenfaces'*meancenter(:,i); % projection of centered images into facespace
    projectedImages = [projectedImages temp]; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating 1d array for the 2d input image
test=chtimg;
for i=1:b(1)*b(2)
    testvector(i,1)=test(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Finding the mean centered test  image
meancenttest=double(testvector)-meanvector;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%projecting the test image as span of eigen faces
projectedTestImage = Eigenfaces'*meancenttest; % Test image feature vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Finding the eucledian distance between test image and data base images
for i=1:p
    euc(i)=(norm(projectedImages(:,i)-projectedTestImage))^2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Image with the minimum eucledian distance is the recognised image
[mindis arg_min]=min(euc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
arg_min
mindis
figure;
imshow(uint8(test));
figure;
stem(euc);
norm=euc./max(euc)