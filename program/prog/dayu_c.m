
%c�д���0��ֵ��255

function  out=dayu_c(c,n)



[row,col]=size(c);

for irow=1:row

    for jcol=1:col

        if c(irow,jcol)>n

            c(irow,jcol)=1;

        else

            c(irow,jcol)=0;

        end

    end

end

out=c;