clc;
clear all;
close all;
midband=[0,0,0,0,1,1,1,0;0,0,0,1,1,1,0,0;0,0,1,1,1,0,0,0;0,1,1,1,0,0,0,0;1,1,1,0,0,0,0,0;1,1,0,0,0,0,0,0;1,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0];
covimg=imread('E:\M Tech\Semester 2\Multimedia Security\Mini Project\lena.jpg');
covimg=imresize(covimg,[256 256]);
for noi=1:10
wmark=25*randn(1,7000);
blocksize=8;
%%%%%%%%%%%%%%%%%%%%%%%%%%% to generate random positions to watermark (c)
a=1+floor(18432*rand(1,18432));
c=unique(a);
b(1)=a(1);
j=2;
for i=2:10000
    c=find(b-a(i));
    temp=max(size((c)));
    sizeofb=max(size(b));
        if temp==sizeofb
            b(j)=a(i);
            j=j+1;
        end
end
c=b(1:7000);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% to generate random positions to watermark (c)
n=1;
%%%%%%%%%%%%%% dont change anything here
for y=1:32
    for z=1:32    
        dctblock=dct2(covimg(((y-1)*blocksize)+1:((y*blocksize)),((z-1)*blocksize)+1:((z*blocksize))));
        l=1;
            for j=1:blocksize
                for k=1:blocksize
                    if (midband(j,k)==1)
                        vect(n)=dctblock(j,k);
                        n=n+1;
                    end
                end
            end
    end
end
%%%%%%%%%%%%%% dont change anything here ends
%%%%%%%%%%%%%% vect contains mid freq components
for i=1:7000
    vect(c(i))=vect(c(i))+wmark(i);
end
%%%%%%%%%%%%%% vect contains watermarked mid freq components
%%%%%%%%%%%%%%%%%%%%%%%%%% Image Replacement Code
n=1;
for y=1:32
    for z=1:32
        dctblock=dct2(covimg(((y-1)*blocksize)+1:((y*blocksize)),((z-1)*blocksize)+1:((z*blocksize))));
        l=1;
            for j=1:blocksize
                for k=1:blocksize
                    if (midband(j,k)==1)
                        dctblock(j,k)=vect(n);
                        n=n+1;
                    end
                end
            end 
      recblock(((y-1)*blocksize)+1:((y*blocksize)),((z-1)*blocksize)+1:((z*blocksize)))=uint8(floor(idct2(dctblock)));
    end
end
str = int2str(noi);
str = strcat('E:\M Tech\Semester 4\Project Work\Watermarked Images\',str,'.bmp');
imwrite(recblock,str,'BMP');
end
%imwrite(recblock,'chtimg50.jpg','jpeg','Quality',50);
%imwrite(recblock,'chtimg50.jpg','jpeg','Quality',50);
%%%%%%%%%%%%%%%%%%%%%%%%%% Image Replacement Code
figure;
imshow(covimg);
title('original image');
figure;
imshow(recblock);
title('Watermarked image');