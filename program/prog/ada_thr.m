
%�Ծ���ȡ����Ӧ��ֵ

function out=ada_thr(c,n,a0)



[row,col]=size(c);



m1=(n+1)/2;%nΪ������ģ��Ĵ�С

m2=(n-1)/2;

temp_c=c;

for irow=m1:(row-m1)

    for jcol=m1:(col-m1)

        if c(irow,jcol)>0

           lefttop_h=irow-m2;%���ϽǺ�����

           lefttop_v=jcol-m2;%���Ͻ�������

           sub_c=sub_m(c,lefttop_h,lefttop_v,n);

           mean_array=sum(sub_c);

           adapt_thr=sum(mean_array)*a0;

           temp_c(irow,jcol)=wthresh(c(irow,jcol),'h',adapt_thr);

        end

    end

end

out=temp_c;