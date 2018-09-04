function y=imfus(I1,I2);
st=cputime;		% ����ʼ����ʱ��cpuʱ��
I1=imread('C:\study\ImageFusion\Pictures\007.jpg');
I2=imread('C:\study\ImageFusion\Pictures\007TI.jpg');
I1=I1(:,:,1);I2=I2(:,:,1);    %��ȡ��ɫRGBͼ��ĵ�һ��ɫ����

[r1,c1]=size(I1);             % ��ȡͼ��ֽ���С���ֽ�ϵ������Ĵ�С
[r2,c2]=size(I2);
if (r1~=r2)||(c1~=c2)
    error('Images dimension mismatch.The image size must be the same!');
    return;
end

dim=1;
figure;                     % ��ģ�����������ͼ�����С���ֽ�
y1=mywavedec2(I1,dim);
figure;
y2=mywavedec2(I2,dim);

[r,c]=size(y1);			% ���ݵ�Ƶ�ں��㷨����ͼ���ں�
for i=1:r			% ����ȡ����Դͼ����Ӧ��С���ֽ�ϵ�����ֵ��Ϊ�ں�ͼ��ķֽ�ϵ��
    for j=1:c
        if ( abs(y1(i,j)) >= abs(y2(i,j)) )
            y3(i,j)=y1(i,j);
        elseif ( abs(y1(i,j)) < abs(y2(i,j)) )
            y3(i,j)=y2(i,j);
        end
    end
end

LLa=y1(1:r/(2^dim),1:c/(2^dim));	% ����lowfrefus�����Ե�Ƶ���ֵ�С���ֽ�ϵ�������ں�
LLb=y2(1:r/(2^dim),1:c/(2^dim));
y3(1:r/(2^dim),1:c/(2^dim))=lowfrefus(LLa,LLb);

yr=mywaverec2(y3,dim);    % ����mywaverec2�����ع��ں�ͼ��

et=cputime-st		% ��������������õ�ʱ��

averEntropy1=averEntropy(I1)
averEntropy2=averEntropy(I2)
averEntropy3=averEntropy(yr)

aveGrad1 = avegrad(I1)
aveGrad2 = avegrad(I2)
aveGrad3 = avegrad(yr)

function y=upspl(x);

N=length(x);        % ��ȡ�������г���
M=2*N-1;            % ������еĳ������������г��ȵ�2���ټ�һ
for i=1:M           % ������е�ż��λΪ0������λ�����������Ӧλ�õ���������Ԫ��
    if mod(i,2)
        y(i)=x((i+1)/2);
    else
        y(i)=0;
    end
end

function [smat,mp,np] = submat(x,p,level)
% ���� submat ȡ����������Ե�PΪ���ġ�����Ϊ��2*level+1���ķ�����Ϊ������Ӿ���

[row,col]=size(x);
m=p(1); n=p(2);

if (m>row)||(n>col)
    error('Point p is out of matrix X !');
    return;
end
if ((2*level+1)>row)||((2*level+1)>col)
    error('Too large sample area level !');
    return;
end
% �����Ӿ���ı߽�ֵ
up=m-level;     down=m+level;
left=n-level;   right=n+level;
% ���Ӿ����ĳһ�߽�ֵ��������������Ӧ�߽磬�ͽ��б߽紦��
% �������߽�����෴����ƽ�ƣ�ʹ��ǡ����߽��غ�
if left<1
    right=right+1-left;
    left=1;
end
if right>col
    left=left+col-right;
    right=col;
end
if up<1
    down=down+1-up;
    up=1;
end
if down>row
    up=up+row-down;
    down=row;
end
% ��ȡ��Ϊ������Ӿ��󣬲������p��������Ӿ����е�λ��
smat = x(up:down,left:right);
mp=m-up+1;np=n-left+1;

function y=mywaverec2(x,dim)
xd=uint8(x);            % �������������ݸ�ʽת��Ϊ�ʺ���ʾͼ���uint8��ʽ
[m,n]=size(x);          % �����������������
for i=1:dim             % ��ת������xd���зֽ��ߴ���
    m=m-mod(m,2);
    n=n-mod(n,2);
    xd(m/2,1:n)=255;
    xd(1:m,n/2)=255;
    m=m/2;n=n/2;
end
figure;
subplot(1,2,1);imshow(xd);title([ num2str(dim) ' ��С���ֽ�ͼ��']);  % �������зֽ��ߵķֽ�ͼ��

xr=double(x);           % �������������ݸ�ʽת�����ʺ���ֵ�����double��ʽ
[row,col]=size(xr);     % ���ת������xr��������
for i=dim:-1:1          % �ع������Ǵ��ڲ��������У������ȳ�ȡ���� xr �����ڲ�ֽ��������ع�
    tmp=xr(1:floor(row/2^(i-1)),1:floor(col/2^(i-1)));       % �ع����ڲ�������������Ϊ����xr��2^(i-1)
    [rt1,ct1]=size(tmp);                         % ��ȡ���ع����� tmp ��������
    rt=rt1-mod(rt1,2);ct=ct1-mod(ct1,2);
    rLL=tmp(1:rt/2,1:ct/2);                    % �����ع����� tmp �ֽ�Ϊ�ĸ�����
    rHL=tmp(1:rt/2,ct/2+1:ct);
    rLH=tmp(rt/2+1:rt,1:ct/2);
    rHH=tmp(rt/2+1:rt,ct/2+1:ct);
    tmp(1:rt,1:ct)=myidwt2(rLL,rHL,rLH,rHH);              % ���ع�������ص����� tmp
    xr(1:rt1,1:ct1)=tmp;       % �Ѿ��� tmp �����ݷ��ص����� xr ����Ӧ����׼����һ�������ع�
end
y=xr;                    % �ع�������õ��ľ���xr��Ϊ������� y
yu=uint8(xr);            % ������xr�����ݸ�ʽת��Ϊ�ʺ���ʾͼ���uint8��ʽ
subplot(1,2,2);imshow(yu);title('С���ع�ͼ��');

function y=mywavedec2(x,dim)
x=modmat(x,dim);            % ���ȹ淶���������ʹ�����������ܱ� 2^dim �������Ӷ�ʹ�ֽ�˳������

subplot(1,2,1);imshow(x);title('ԭʼͼ��');   % �����淶�����Դͼ��
[m,n]=size(x);              % ����淶������x��������
xd=double(x);               % ������x�����ݸ�ʽת��Ϊ�ʺ���ֵ�����double��ʽ

for i=1:dim
    xd=modmat(xd,1);
    [dLL,dHL,dLH,dHH]=mydwt2(xd);   % ����С���ֽ�
    tmp=[dLL,dHL;dLH,dHH];          % ���ֽ�ϵ�����뻺�����
    xd=dLL;                         % ������������Ͻǲ��ֵ��Ӿ�����Ϊ��һ��ֽ��Դ����
    [row,col]=size(tmp);            % �����������������
    y(1:row,1:col)=tmp;             % ����������������������Ӧ����
end

yd=uint8(y);            % �������������ݸ�ʽת��Ϊ�ʺ���ʾͼ���uint8��ʽ
for i=1:dim             % �Ծ��� yd ���зֽ��ߴ��������ֽ�ͼ��ķֽ���
    m=m-mod(m,2);
    n=n-mod(n,2);
    yd(m/2,1:n)=255;
    yd(1:m,n/2)=255;
    m=m/2;n=n/2;
end
subplot(1,2,2);imshow(yd);title([ num2str(dim) ' ��С���ֽ�ͼ��']);

function y=myidwt2(LL,HL,LH,HH)
lpr=[1 1];hpr=[1 -1];           % Ĭ�ϵĵ�ͨ����ͨ�˲���
tmp_mat=[LL,HL;LH,HH];          % ��������ĸ��������Ϊһ������
[row,col]=size(tmp_mat);        % �����Ͼ����������

for k=1:col                     % ���ȶ���Ͼ���tmp_mat��ÿһ�У��ֿ�����������
    ca1=tmp_mat(1:row/2,k);     % �ֿ��������ֱַ���Ϊƽ��ϵ������ca1��ϸ��ϵ������cd1
    cd1=tmp_mat(row/2+1:row,k);
    tmp1=myidwt(ca1,cd1,lpr,hpr);   % �ع�����
    yt(:,k)=tmp1;                % ���ع����д����������� yt ����Ӧ�У���ʱ y=[L|H]
end

for j=1:row                     % ��������� y ��ÿһ�У��ֿ�����������
    ca2=yt(j,1:col/2);           % �ֿ��������ֱַ���Ϊƽ��ϵ������ca2��ϸ��ϵ������cd2
    cd2=yt(j,col/2+1:col);
    tmp2=myidwt(ca2,cd2,lpr,hpr);   % �ع�����
    yt(j,:)=tmp2;                % ���ع����д����������� yt ����Ӧ�У��õ����յ�������� y=yt
end
y=yt;

function y = myidwt(cA,cD,lpr,hpr);
lca=length(cA);             % ���ƽ����ϸ�ڲ��ַֽ�ϵ���ĳ���
lcd=length(cD);

while (lcd)>=(lca)          % ÿһ���ع��У�cA �� cD �ĳ���Ҫ��ȣ���ÿ���ع���
                            % ��lcdС��lca�����ع�ֹͣ����ʱ�� cA ��Ϊ�ع��ź����� y ��
    upl=upspl(cA);          % ��ƽ������ϵ�������ϳ���
    cvl=conv(upl,lpr);      % ��ͨ���
    
    cD_up=cD(lcd-lca+1:lcd);    % ȡ�������ع������ϸ�ڲ���ϵ���������뱾��ƽ������ϵ���ĳ������
    uph=upspl(cD_up);       % ��ϸ�ڲ���ϵ�������ϳ���
    cvh=conv(uph,hpr);      % ��ͨ���
    
    cA=cvl+cvh;             % �ñ����ع������и���cA���Խ�����һ���ع�
    cD=cD(1:lcd-lca);       % ���������ع��õ���ϸ�ڲ���ϵ��������cD
    lca=length(cA);         % �����һ���ع����õ�ƽ����ϸ�ڲ���ϵ���ĳ���
    lcd=length(cD);
end                         % lcd < lca���ع���ɣ�����ѭ��
y=cA;                       % ������ع����� y �����ع���ɺ��ƽ������ϵ������ cA

function [LL,HL,LH,HH]=mydwt2(x);
lpd=[1/2 1/2];hpd=[-1/2 1/2];           % Ĭ�ϵĵ�ͨ����ͨ�˲���
[row,col]=size(x);                      % ��ȡ�������Ĵ�С

for j=1:row                             % ���ȶ���������ÿһ�����н���һά��ɢС���ֽ�
    tmp1=x(j,:);
    [ca1,cd1]=mydwt(tmp1,lpd,hpd,1);
    x(j,:)=[ca1,cd1];                   % ���ֽ�ϵ�������ٴ������x�У��õ�[L|H]
end
for k=1:col                             % �ٶ���������ÿһ�����н���һά��ɢС���ֽ�
    tmp2=x(:,k);
    [ca2,cd2]=mydwt(tmp2,lpd,hpd,1);
    x(:,k)=[ca2,cd2];                   % ���ֽ�����ϵ���������x�У��õ�[LL,Hl;LH,HH]
end

LL=x(1:row/2,1:col/2);                  % LL�Ǿ���x�����Ͻǲ���
LH=x(row/2+1:row,1:col/2);              % LH�Ǿ���x�����½ǲ���
HL=x(1:row/2,col/2+1:col);              % HL�Ǿ���x�����Ͻǲ���
HH=x(row/2+1:row,col/2+1:col);          % HH�Ǿ���x�����½ǲ���

function [cA,cD] = mydwt(x,lpd,hpd,dim);
cA=x;       % ��ʼ��cA��cD
cD=[];
for i=1:dim
    cvl=conv(cA,lpd);   % ��ͨ�˲���Ϊ����������ٶȣ�����MATLAB�ṩ�ľ������conv()
    dnl=downspl(cvl);   % ͨ���³������ƽ�����ֵķֽ�ϵ��
    cvh=conv(cA,hpd);   % ��ͨ�˲�
    dnh=downspl(cvh);   % ͨ���³����������ֽ���ϸ�ڲ���ϵ��
    cA=dnl;             % �³������ƽ������ϵ��������һ��ֽ�
    cD=[cD,dnh];        % ������ֽ����õ�ϸ�ڲ���ϵ����������cD
end

function y=modmat(x,dim)
[row,col]=size(x);          % �����������������row,col
rt=row - mod(row,2^dim);    % ��row,col�ֱ��ȥ����ģ 2^dim �õ�����
ct=col - mod(col,2^dim);    % ���õĲ�Ϊrt��ct�����ܱ� 2^dim ����
y=x(1:rt,1:ct);             % ������� y Ϊ������� x �� rt*ct ά�Ӿ���

function y = lowfrefus(A,B);
[row,col]=size(A);	% ����ֽ�ϵ�������������
alpha=0.5;		% alpha�Ƿ���ƥ��ȱȽϵ���ֵ
for i=1:row		% ���ݵ�Ƶ�ں��㷨�����������A,B���Ե�PΪ���ĵ����򷽲�ͷ���ƥ���
    for j=1:col		% �ٸ��ݷ���ƥ�������ֵ�ıȽ�ȷ���ں�ͼ���С���ֽ�ϵ��
        [m2p(i,j),Ga(i,j),Gb(i,j)] = area_var_match(A,B,[i,j]);
        Wmin=0.5-0.5*((1-m2p(i,j))/(1-alpha));
        Wmax=1-Wmin;
        if m2p(i,j)<alpha		% m2p��ʾ����ƥ���
            if Ga(i,j)>=Gb(i,j)		% ��ƥ���С����ֵ����ȡ���򷽲�����Ӧ��ķֽ�ϵ����Ϊ�ں�ͼ��ķֽ�ϵ��
                y(i,j)=A(i,j);
            else
                y(i,j)=B(i,j);
            end
        else				% ��ƥ��ȴ�����ֵ�����ȡ��Ȩƽ�������ó���Ӧ�ķֽ�ϵ��
            if Ga(i,j)>=Gb(i,j)
                y(i,j)=Wmax*A(i,j)+Wmin*B(i,j);
            else
                y(i,j)=Wmin*A(i,j)+Wmax*B(i,j);
            end
        end
    end
end

function w = weivec(x,p);
[r,c]=size(x);
p1=p(1);    p2=p(2);
sig=1;
for i=1:r
    for j=1:c
        w(i,j)=0.5*(gaussmf(i,[sig p1])+gaussmf(j,[sig p2]));
    end
end

function [m2p,Ga,Gb] = area_var_match(A,B,p);
level=1;	% ��������Ĵ�С
[subA,mpa,npa]=submat(A,p,level);	% submat ����ȡ����������Ե�PΪ���ġ�����Ϊ��2*level+1���ķ�����Ϊ�Ӿ���
[subB,mpb,npb]=submat(B,p,level);

[r,c]=size(subA);
w=weivec(subA,[mpa npa]);	% ��ȡ�Ӿ����Ȩֵ�ֲ�

averA=sum(sum(subA))/(r*c); % �����Ӿ����ƽ��ֵ
averB=sum(sum(subB))/(r*c);

Ga=sum(sum(w.*(subA-averA).^2));    % �����Ӿ�������򷽲�
Gb=sum(sum(w.*(subB-averB).^2));
if (Ga==0)&(Gb==0)      % ���������Ӿ�������򷽲�ƥ���
    m2p=0;
else
    m2p=2*sum(sum(w.*abs(subA-averA).*abs(subB-averB)))/(Ga+Gb);
end

function y=flor(x);
y=x-mod(x,1);

function y=downspl(x);
N=length(x);        % ��ȡ�������г���
M=floor(N/2);        % ������еĳ������������г��ȵ�һ�루��С��ʱȡ�������֣�
i=1:M;
y(i)=x(2*i);

%^^^^^^^^^^^^^^^^^^ Compute Entropy Of Image ^^^^^^^^^^^^^
function AVERENTROPY=averEntropy(img)
% remove zero entries in I1
I1=double(img);
I1(I1==0) = [];
% normalize I1 so that sum(I1) is one.
I1 = I1./numel(I1);
Entropy = -sum(I1.*log2(I1));
AVERENTROPY = sum(Entropy)/size(Entropy,2);

function AVEGRAD=avegrad(img)
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% this function is used to calculate
%%%% the average gradient of an image.
%%%% ƽ���ݶȿ����еط�ӳͼ���΢Сϸ�ڷ����������������������ͼ���ģ���̶�
%%%% ��ͼ���У�ĳһ����ĻҶȼ��仯�ʴ������ݶ�Ҳ�ʹ���ˣ�������ƽ���ݶ�ֵ
%%%% ������ͼ��������ȣ���ͬʱ��ӳ��ͼ����΢Сϸ�ڷ��������任������

img=double(img);
[M,N]=size(img);
gradval=zeros(M,N); %%% save the gradient value of single pixel
diffX=zeros(M,N);    %%% save the differential value of X orient
diffY=zeros(M,N);    %%% save the differential value of Y orient

tempX=zeros(M,N);
tempY=zeros(M,N);
tempX(1:M,1:(N-1))=img(1:M,2:N);
tempY(1:(M-1),1:N)=img(2:M,1:N);

diffX=img-tempX;
diffY=img-tempY;
diffX(1:M,N)=0;       %%% the boundery set to 0
diffY(M,1:N)=0;
diffX=diffX.*diffX;
diffY=diffY.*diffY;
AVEGRAD=sum(sum(diffX+diffY));
AVEGRAD=sqrt(AVEGRAD);
AVEGRAD=AVEGRAD/((M-1)*(N-1)); 
