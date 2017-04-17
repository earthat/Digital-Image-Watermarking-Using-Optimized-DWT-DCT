function [message_vector,Mo,No] = retriv1(watermrkd_img,message)
pn_sequence_search='T';
 
blocksize=8;
midband=[   0,0,0,1,1,1,1,0;    % defines the mid-band frequencies of an 8x8 dct
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0 ];

watermarked_image= watermrkd_img;
% determine size of watermarked image
Mw=size(watermarked_image,1);           %Height
Nw=size(watermarked_image,2);           %Width
 
% read in original watermark

orig_watermark=double(message);
 
% determine size of original watermark
Mo=size(orig_watermark,1);  %Height
No=size(orig_watermark,2);  %Width
 
% read in key for PN generator
file_name='_key.bmp';
key=double(imread(file_name))./256;
 
 
 
% reset MATLAB's PN generator to state "key"
j = 1;
for i =1:length(key)
rand('state',key(i,j));
end
message_vector=ones(1,Mo*No);
[cA1,cH1,cV1,cD1] = dwt2(watermarked_image,'haar');
%................ perform DCT on cH1......................................
 pn_sequence_one=round(2*(rand(1,sum(sum(midband)))-0.5));
pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));
% pn_sequence_one=round(2*(rand(blocksize,blocksize)-0.5));
% pn_sequence_zero=round(2*(rand(blocksize,blocksize)-0.5));
 
if (pn_sequence_search=='T')
    while (corr2(pn_sequence_one,pn_sequence_zero) > -0.55)
         pn_sequence_one=round(2*(rand(1,sum(sum(midband)))-0.5));
         pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));
    end
end
% process the image in blocks
x=1;
y=1;
for kk = 1:length(message_vector)
     
    % transform block using DCT
    dct_block=dct2(cH1(y:y+blocksize-1,x:x+blocksize-1));
    
    % if message bit contains zero then embed pn_sequence_zero into the mid-band
    % componants of the dct_block
     ll=1;
%     if (message_vector(kk)==0)
        for ii=1:blocksize
            for jj=1:blocksize
                if (midband(jj,ii)==1)
                    sequence(ll)=dct_block(jj,ii);
                   ll=ll+1;
                end
            end
        end
%     end
    % calculate the correlation of the middle band sequence with pn_sequences
    % and choose the value with the higher correlation for message
    
    cor_zero_h(kk)=corr2(pn_sequence_zero,sequence);    
    cor_one_h(kk)=corr2(pn_sequence_one,sequence);
    % move on to next block. At and of row move to next row
    if (x+blocksize) >= Nw/2
        x=1;
        y=y+blocksize;
        if y>=256
            break
        end
    else
        x=x+blocksize;
    end
                    
end
 
x =1;
y =1;
for kk = 1:length(message_vector)
     
    % transform block using DCT
    dct_block=dct2(cV1(y:y+blocksize-1,x:x+blocksize-1));
    
    % if message bit contains zero then embed pn_sequence_zero into the mid-band
    % componants of the dct_block
    ll=1;
%     if (message_vector(kk)==0)
        for ii=1:blocksize
            for jj=1:blocksize
                if (midband(jj,ii)==1)
                    sequence(ll)=dct_block(jj,ii);
                ll=ll+1;
                end
            end
        end
%     end
    % calculate the correlation of the middle band sequence with pn_sequences
    % and choose the value with the higher correlation for message
    
    cor_zero_v(kk)=corr2(pn_sequence_zero,sequence);
    cor_one_v(kk)=corr2(pn_sequence_one,sequence);
    % move on to next block. At and of row move to next row
    if (x+blocksize) >= Nw/2
        x=1;
        y=y+blocksize;
        if y>=256
            break
        end
    else
        x=x+blocksize;
    end
                    
 
end
 
for kk = 1:length(message_vector)
    
    correlation_one(kk)=(cor_one_h(kk)+cor_one_v(kk))/2;
    correlation_zero(kk)=(cor_zero_h(kk)+cor_zero_v(kk))/2; 
    if correlation_zero(kk) > correlation_one(kk)
        message_vector(kk)=0;
    else
        message_vector(kk)=1;
    end
 
end

end

