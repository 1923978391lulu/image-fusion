% ����a��c���Ƿ������ڵ�n����
function out=rank_c(c,a,n)
[row,col]=size(c);
n=1;
for irow=1:row
    for jcol=1:col
        if c(irow,jcol)>a 
            n=n+1;
            if n>a
               break; 
            end;
        end
    end
    if n>a
       break; 
    end
end
if n>a
   out=1;
else
   out=0;
end
