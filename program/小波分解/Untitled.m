    x = imread('C:\study\ImageFusion\Pictures\007.jpg');  
      
    %תΪ�Ҷ�ͼ��  
    X = rgb2gray(x);  
      
    %��db1С�������ֽ�,�ֽ����Ϊ2  
    %������X = waverec2(C, S, 'db1')�����ع�  
    [C, S] = wavedec2(X, 2, 'db1');  
    %��ȡ2��ĵ�Ƶϵ��  
    a = appcoef2(C, S, 'db1', 3);  
    %��ȡ2������и�Ƶϵ��  
    [h, v, d] = detcoef2('all', C, S, 2);  
    c = [a, h; v, d];  
      
      
    %��c�����ֵ���쵽0-255��b=uint((a-min(a(:)))./(max(a(:))-min(a(:)))*255);   
    imshow(c,[]);  