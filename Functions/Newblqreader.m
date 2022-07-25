%function  [curva,hname,text] = Newblqreader( fname )
function  [curva,Temp,Field,Direction] = Newblqreader( fname )
% Si solo hay una variable de salida, se comporta como antes y devuelve un
% struct con cada curva del BLQ

% Si tenemos varias variables de salida, obtenemos tambien la informacion
% de temperatura, campo magnetico e ida/vuelta del BLQ y lo sacamos como
% variables

%fprintf('Output number: %i\n',nargout)

fid = fopen (fname,'r','l','windows-1252'); 
%fijamos la codificacion de caracteres para asegurarnos que no hace nada raro

in = 0;
if nargout > 1
    while true
        %cabecera 400 bytes
        in      = in + 1;
        fread (fid, 4, 'uint16'); %no sabemos que es
        hname   = char(fread (fid, 32,'char*1')'); %nombre
        if isempty(hname),   break,   end %terminamos si esta vacio
        hn      = fread (fid, 2, 'int32');
                  fread(fid,2,'float64'); %tiempo al medir en segundos
        text    = char(fread(fid,336,'char*1')'); %commentario y padding

        ncols   = hn(1);
        nrows   = hn(2);
    
        curva(in).data = readblqcolumns(fid,ncols,nrows);

        C   = textscan(char(text),'%s %s %s %s %s %s',Delimiter='\n');
        CT  = textscan(C{2}{:},'%s %f',Delimiter='=');
        Temp(in) = CT{2};

        CB  = textscan(C{3}{:},'%s %f',Delimiter='=');
        Field(in)= CB{2};

        CFB=textscan(C{6}{:},'%s %*[^\n]',Delimiter=char(0));
        Direction{in}=char(CFB{1});

    end
else
    while true
        %cabecera 400 bytes Solo Leo lo absolutamente necesario.
        in = in + 1;
        fread (fid, 4, 'uint16'); %no sabemos que es
        hname = char(fread (fid, 32,'char*1')'); %nombre
        if isempty(hname),   break,   end %terminamos si esta vacio
        hn = fread (fid, 2, 'int32');
        fseek(fid,352,'cof'); %saltamos el comentario


        ncols   = hn(1);
        nrows   = hn(2);

        curva(in).data = readblqcolumns(fid,ncols,nrows);

    end
end

fclose(fid);
end