%С��ͼ���ں�Demo
%�汾1.00
%������˵���㷨���ǽ�С���任��Ķ����ÿ��Ķ�Ӧϵ������ֵȡ�� Ȼ���ٽ�����ͼ��Ķ�Ӧԭ����Ԫ��ȡ��ֵ�����������С���ع�������ʵ������ͼ����ںϡ�
clear all;
close all;
%�û���ϵ������ֵ���׼��
%С���� bior2.4˫����С��
wavelet='bior2.4';
%�ֽ����Ϊ����
level = 2;
%������ͼ��תΪ���ݾ���
im1=imread('C:\study\ImageFusion\Pictures\007.jpg');
im2=imread('C:\study\ImageFusion\Pictures\007TI.jpg');
%�ֱ�ȡ��ά����ĵ�һά
a=im1(:,:,1);
b=im2(:,:,1);

[Ca,Sa] = wavedec2(a,level,wavelet);
[Cb,Sb] = wavedec2(b,level,wavelet);
%ȡ��2���Ƶ�ķֽ�ϵ����С


x=Sa(2,:);
y=Sa(1,:);
z=Sa(3,:);
Ra = zeros(size(Ca));

%����Ƶȡ������ȡ��
for n=1:2
     %����n��ˮƽ,��ֱ���ԽǸ�Ƶ������ͼ������ȡ��
for m=1:3
    if n==1
        ylow=y(1)*y(2)+(m-1)*x(1)*x(2);
        Ta = zeros(x(1),x(2));
        Tb = zeros(x(1),x(2));
        cl=Ta;
    elseif n==2
        ylow=y(1)*y(2)+3*x(1)*x(2)+(m-1)*z(1)*z(2);
        Ta = zeros(z(1),z(2));
        Tb = zeros(z(1),z(2));
        cl=Ta;
    end
    
%���ڶ���ˮƽ��Ƶ��ԭΪ����ֱ�ΪTa��Tb
    [Taline,Tarow]=size(Ta);
for i=1:Taline
    for j=1:Tarow
        Ta(i,j)=Ca((i-1)*Tarow+j+ylow);
        Tb(i,j)=Cb((i-1)*Tarow+j+ylow);
    end
end


%�ֱ������������������бȽ�

for i=1:(Taline)
    for j=1:(Tarow)
 Tta=0;
Ttb=0;
Tta2=0;
Ttb2=0;
       %��ÿһ��С����Ԫ�����
       if i>=2 && i<=(Taline-1) && j>=2 && j<=(Tarow-1)
        for k=1:3
            for p=1:3
                Tta=Tta+Ta(i+k-2,j+p-2);
                Ttb=Ttb+Tb(i+k-2,j+p-2);
            end
        end
        %�������
        for k=1:3
            for p=1:3
                Tta2=Tta2+[Ta(i+k-2,j+p-2)-(Tta/9)].^2;
                Ttb2=Ttb2+[Tb(i+k-2,j+p-2)-(Ttb/9)].^2;
            end
        end
        %���бȽϣ��������������һ���¾���Ra
        if Tta2>=Ttb2
            cl(i,j)=Ta(i,j);
%         else
%             cl(i,j)=Tb(i,j);
        end
       else
           cl(i,j)=Ta(i,j);
       end
    end
end
%�������ľ���ת���������
for i=1:Taline
    for j=1:Tarow
        Ra((i-1)*Tarow+j+ylow)=cl(i,j);
    end
end
     
end
end

 

%ȡһ����ֽ�ϵ������Ca�е�����������ͬ��0����

%���ڵ�2���Ƶȡ����ͼ���Ӧ����Ԫ�ص�ƽ��ֵ����Ϊ���ɾ����Ԫ�ء�
for p=1:y(1)*y(2)
Ra(p)=(Ca(p)+Cb(p))/2;
end


%��ά��ɢС���Ķ���ع��� �ڴ�Ϊ5���ع���
result = waverec2(Ra,Sa,wavelet);
%���ںϺ�ͼ��ȡ������unit8��λ��
res= uint8(round(result));
%��ʾ�����ԡ�С��ϵ��ȡ�������Ϊ����
figure;
imshow(res);
title('С��ϵ��ȡ�������');