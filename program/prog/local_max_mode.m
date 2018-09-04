%������ϸ��v�ͺ���ϸ��h�ĺϳɼ�ģ����ֵ
function [out1,out2] = local_max_mode(v,h,thr,a0,n);

[row,col] =size(v);

for irow=1:row
    for jcol=1:col
        mf(irow,jcol) = sqrt(v(irow,jcol)^2 + h(irow,jcol)^2);
        af(irow,jcol) = atand(v(irow,jcol)/(h(irow,jcol)+eps));
    end
end

m1=(n+1)/2;%nΪ������ģ��Ĵ�С
m2=(n-1)/2;

max_mf=wthresh(mf,'h',thr);
temp_mf=max_mf;
%��ģ��ȡ����Ӧ��ֵ
for irow=m1:(row-m1)
    for jcol=m1:(col-m1)
        if max_mf(irow,jcol)>0
           lefttop_h=irow-m2;%���ϽǺ�����
           lefttop_v=jcol-m2;%���Ͻ�������
           sub_c=sub_m(max_mf,lefttop_h,lefttop_v,n);
%            mean_arry=mean(sub_c);
%            mean_thr=mean(mean_arry);
%            sub_c=wthresh(sub_c,'h',mean_thr);
           if rank_c(sub_c,max_mf(irow,jcol),m1^2)
              temp_mf(irow,jcol)=0;
           else
              mean_array=mean(sub_c);
              adapt_thr=mean(mean_array)*a0;
              temp_mf(irow,jcol)=wthresh(max_mf(irow,jcol),'h',adapt_thr);
           end
        end
    end
end

max_mf=temp_mf;
edge_mf(row,col)=0;%ģ�ļ���ֵ
% grad(row,col)=-1;%�ݶȷ���

% -1����Ǽ�ֵ��
% 0����-22.5����22.5��
% 1����22.5����67.5��
% 3����-22.5����-67.5��
% 2����67.5����90���Լ�-67.5����-90��

for irow=2:row-1
    for jcol=2:col-1
       if max_mf(irow,jcol)<=0
          if max_mf(irow,jcol)>=max_mf(irow+1,jcol)
             edge_mf(irow,jcol) = max_mf(irow,jcol);
          else
             edge_mf(irow,jcol)=0;
          end
       end
       atan_temp=af(irow,jcol);
       switch atan_temp
           case (atan_temp>=-22.5)&(atan_temp<22.5)
                if (max_mf(irow,jcol+1)<=max_mf(irow,jcol))&(max_mf(irow,jcol-1)<=max_mf(irow,jcol))
                    edge_mf(irow,jcol) = max_mf(irow,jcol);
                end
           case (atan_temp>=22.5)&(atan_temp<67.5)
                
                if (max_mf(irow-1,jcol+1)<=max_mf(irow,jcol))&(max_mf(irow+1,jcol-1)<=max_mf(irow,jcol))
                    edge_mf(irow,jcol) = max_mf(irow,jcol);
                end
           case (atan_temp>=-67.5)&(atan_temp<-22.5)
                if (max_mf(irow-1,jcol-1)<=max_mf(irow,jcol))&(max_mf(irow+1,jcol+1)<=max_mf(irow,jcol))
                    edge_mf(irow,jcol) = max_mf(irow,jcol);
                end
           otherwise
                if (max_mf(irow-1,jcol)<=max_mf(irow,jcol))&(max_mf(irow+1,jcol)<=max_mf(irow,jcol))
                    edge_mf(irow,jcol) = max_mf(irow,jcol);
                end
       end %end switch
       
   end
end

out1 = edge_mf;
out2 = af;
