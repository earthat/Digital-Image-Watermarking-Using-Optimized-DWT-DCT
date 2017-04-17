function [message_vector,Mo,No] = dwtrecover(watermrkd_img,k,message)

watermarked_image= watermrkd_img;
% determine size of watermarked image
Mw=size(watermarked_image,1);           %Height
Nw=size(watermarked_image,2);           %Width
 Ow=size(watermarked_image,3);
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
 
 % add pn sequences to H1 and V1 componants when message = 0 
for (kk=1:length(message_vector))
    pn_sequence_h=round(2*(rand(Mw/2,Nw/2,Ow)-0.5));
    pn_sequence_v=round(2*(rand(Mw/2,Nw/2,Ow)-0.5));
    
    if (message(kk) == 0)
%         cH1(:,:,1)=cH1(:,:,1)+k*pn_sequence_h;
%         cV1(:,:,1)=cV1(:,:,1)+k*pn_sequence_v;
        cH1=cH1+k*pn_sequence_h;
        cV1=cV1+k*pn_sequence_v;
    end  

 
cor_h(kk)=corr2(pn_sequence_h(:,:,1),cH1(:,:,1));
cor_v(kk)=corr2(pn_sequence_v(:,:,1),cV1(:,:,1));
    if cor_h(kk) > cor_v(kk)
        message_vector(kk)=0;
    else
        message_vector(kk)=1;
    end
end
end



