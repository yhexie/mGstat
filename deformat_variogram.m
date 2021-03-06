% deformat_variogram : convert gstat variogram line into matlab structure
%
% Call:
%   V=deformat_variogram(txt);
% 
% Example: 
% V=deformat_variogram('1 Sph(2)')
%
%V = 
%
%     par1: 1
%     par2: 2
%     type: 'Sph'
%     itype: 1
% 
% 
% See also : format_variogram
%
% TMH /2004
%

function V=deformat_variogram(txt);

  
  txt=regexprep(txt,'\<;','');
  
  % find position of '+' separating multiple models
  fp=regexp(txt,'\+');
  
  % makse sure 'e+' does not count as seperators
  fp_use=fp;
  for ip=1:length(fp);
      if strcmp(txt(fp(ip)-1),'e');
          % fp(ip) is not the locaton of a seprator
          fp_use=setxor(fp_use,fp(ip));
      end
  end
  fp=fp_use;
  
  nvar=length(fp)+1;
  % disp(sprintf('Found %d variograms',nvar))  

  
  if  nvar==1,
    ifp_array=[0];
  else
    ifp_array=[0 fp];
  end
	
  ivar=0;  
  for ifp=1:length(ifp_array);
    ivar=ivar+1;
    if nvar==1,
      vartxt=txt;
    else
      if ifp_array(ifp)==0,
        vartxt=txt(1:fp(1)-1);
      elseif ifp_array(ifp)==max(fp)
        vartxt=txt(ifp_array(ifp)+1:length(txt));
			else
				ind1=ifp_array(ifp)+1;
				ind2=ifp_array(ifp+1)-1;
        vartxt=txt(ind1:ind2);				
				%      else
			%	keyboard
   %     mgstat_verbose('MORE THAN TWO VARIOGRAMS NOT IMPLEMENTED YET',0)
      end
    end
    
    vartxt=strip_space(vartxt);
	%disp(sprintf('ivar=%d ifp=%d --%s--',ivar,ifp,vartxt))
    
    sp=find(vartxt==' ');
    lb=find(vartxt=='(');
    rb=find(vartxt==')');
    
    par1=vartxt(1:sp-1);
    par2=vartxt(lb+1:rb-1);
    type=strip_space(vartxt(sp+1:lb-1));
    
    if ~isempty(str2num(par1)), par1=str2num(par1); end
    if ~isempty(str2num(par2)), par2=str2num(par2); end
    
    if isempty(par2), par2=[];end

		if (strcmp(type,'Nug'))
			itype=0;
		elseif (strcmp(type,'iNug')),
			itype=14;
		elseif (strcmp(type,'Sph')),
			itype=1;
		elseif (strcmp(type,'Gau'))
			itype=3;
		elseif (strcmp(type,'Exp'))
			itype=2;
		elseif (strcmp(type,'Log'))
			itype=15;
		elseif (strcmp(type,'Lin'))
			itype=6;
		elseif (strcmp(type,'Pow'))
			itype=4;
		elseif (strcmp(type,'Hole'))
			itype=5;
		elseif (strcmp(type,'Bal'))
			itype=10;
		elseif (strcmp(type,'Thi'))
			itype=11;
		elseif (strcmp(type,'Mat'))
            itype=12;
        elseif (isempty(type))
            itype=-1;
        else 
			disp(sprintf('%s : Unknown semivariogram type : %s ',mfilename,type))
			itype=8;			
		end
		
		% disp(sprintf('par1=%5.1f par2=%5.1f type=%4s itype=%d',par1,par2,type,itype))
    
    if length(par2)==2, 
        V(ivar).nu=par2(2);
        par2=par2(1);     
    end
    if length(par2)==4, 
        V(ivar).nu=par2(4);
        par2=par2(1:3);       
    end
    if length(par2)==7, 
        V(ivar).nu=par2(7);
        par2=par2(1:6);       
    end
    
    V(ivar).par1=par1;
    V(ivar).par2=par2;
    V(ivar).type=type;
    V(ivar).itype=itype;
    
  end
