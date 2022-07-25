function data0 = readblqcolumns(fid, ncols, nrows)

        data0    = zeros(nrows,ncols);

        for ni = 1 : ncols
            hvda       =  fread(fid, 2, 'uint16');
            fread(fid, 2, 'int32'); %out
            hofss      =  fread (fid, 4, 'float64');
            fread(fid,84,'uchar');
            dataformat =  hvda(2);
            offset     =  hofss(1);
            factor     =  hofss(2);
            start      =  hofss(3);
            size       =  hofss(4);

            switch dataformat
                case 0
                    data = (offset + start + (size/nrows)*(0:(nrows-1)));
                    data = data';
                case 1
                    data = factor*(fread (fid, nrows, 'int8'));
                case 2
                    data = factor*(fread (fid, nrows, 'int16'));
                case 4
                    data = factor*(fread (fid, nrows, 'float32'));
                case 8
                    data = factor*(fread (fid, nrows, 'float64'));
            end
            data0(:,ni) =  data;
        end

end
