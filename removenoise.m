clc;clear;
maindir = 'C:\Users\Administrator\Desktop\例子图片\分类后';
dir1='C:\Users\Administrator\Desktop\例子图片\重分类';
dir2='C:\Users\Administrator\Desktop\例子图片\去噪后';
subdir  = dir( maindir );

for num = 1 : length( subdir )
    if( isequal( subdir( num ).name, '.' )||...
        isequal( subdir( num ).name, '..'))               % 如果不是目录则跳过
        continue;
    end
    subdirpath = fullfile( maindir, subdir( num ).name);
    outputpath1=fullfile( dir1,subdir( num ).name );
    outputpath2=fullfile( dir2,subdir(num ).name );
   % strIndex = regexp(subdir( num ).name, '_', 'split');
   % picname=strIndex(1);
    disp(subdir( num ).name)
    I=imread(subdirpath);
    %I=imread('C:\Users\Administrator\Desktop\例子图片\分类后\93_0.png');
   R=I(:,:,1);G=I(:,:,2);B=I(:,:,3);
   [m,n]=size(R);



for i=1:m
    for j=1:n
        if (R(i,j)==192&&G(i,j)==192&&B(i,j)==128)||(R(i,j)==192&&G(i,j)==128&&B(i,j)==128)
            R(i,j)=128;G(i,j)=0;B(i,j)=0;        
        elseif(R(i,j)==64&&G(i,j)==0&&B(i,j)==128)||(R(i,j)==0&&G(i,j)==128&&B(i,j)==192)
             R(i,j)=64;G(i,j)=64;B(i,j)=0; 
        elseif(R(i,j)==255&&G(i,j)==69&&B(i,j)==0)
            R(i,j)=128;G(i,j)=64;B(i,j)=128;
         end
        
    end
end   
I1(:,:,1)=R;
I1(:,:,2)=G;
I1(:,:,3)=B;
imwrite(I1,outputpath1 , 'JPG'); 


BW1=rgb2gray(I);
%imwrite(BW1, 'C:\Users\Administrator\Desktop\例子图片\去噪后\rnrc163_60.png', 'PNG');
B1=BW1;
BWbuild=zeros(m,n);
for i=1:m
    for j=1:n
        if(BW1(i,j)==38)
            BWbuild(i,j)=1;
        end
    end
end
Lbuild=bwlabeln(BWbuild,8);
Sbuild=regionprops(Lbuild,'Area');
BWbuild2=ismember(Lbuild,find([Sbuild.Area]<=200));
[BWbuild3,Lbuild2]=bwboundaries(BWbuild2,8);
%根据面积过小区域边界周围灰度值，重新给灰度图对应区域赋值 
for k = 1:length(BWbuild3)
    noise=0; tree=0; road=0; pavement=0; sky=0;fench=0;build=0;
    boundary = BWbuild3{k}; 
    for h = 1:length(boundary)
        c = boundary(h,1); 
        x = boundary (h,2);
        if (c>1&&c<360&&x>1&&x<480)
    for y = c-1 : c+1
        for cu = x-1 : x+1 
            switch B1(y,cu)
                case 57
                    noise=noise+1;
                case 67
                    pavement=pavement+1;
                case 90
                    road=road+1;
                case 128
                    sky=sky+1;
                case 113
                    sky=sky+1;
                case 71
                    fench=fench+1;
%                 case 38
%                     build=build+1;
            end
        end
    end
        end


F=[noise pavement road tree sky fench ];
switch max(F)
      case noise
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=57; R(i,j)=64;G(i,j)=64;B(i,j)=0; 
             end
            end
          end
          case tree
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=113; R(i,j)=128;G(i,j)=128;B(i,j)=0; 
             end
            end
          end
          case road
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=90;R(i,j)=128;G(i,j)=64;B(i,j)=128;
             end
            end
          end
           case pavement
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=67;R(i,j)=60;G(i,j)=40;B(i,j)=222;
             end
            end
          end
           case sky
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=128;R(i,j)=128;G(i,j)=128;B(i,j)=128;
             end
            end
          end 
           case fench
          for i=1:m
            for j=1:n
             if Lbuild2(i,j)==k
                B1(i,j)=71;R(i,j)=64;G(i,j)=64;B(i,j)=128;
             end
            end
          end 
%           case build
%           for i=1:m
%             for j=1:n
%              if Lbuild2(i,j)==k
%                 B1(i,j)=38;R(i,j)=128;G(i,j)=0;B(i,j)=0;
%              end
%             end
%           end 
   end  
    end
end
I2(:,:,1)=R;
I2(:,:,2)=G;
I2(:,:,3)=B;

imwrite(I2, outputpath2, 'JPG');
end