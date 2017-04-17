function [watermrkd_img,PSNR,IF,NCC,recmessage] = dwt(cover_object,message,k)
h=msgbox('Processing');
blocksize=8;
 message1 =message;
% determine size of watermarked image
Mc=size(cover_object,1);    %Height
Nc=size(cover_object,2);    %Width
Oc=size(cover_object,3);	%Width 
max_message=Mc*Nc/(blocksize^2);
 

if (length(message) > max_message)
    error('Message too large to fit in Cover Object')
end
 
Mm=size(message,1);                         %Height
Nm=size(message,2);                         %Width
message=round(reshape(message,Mm*Nm,1)./256);
message_vector=ones(1,max_message);
% message_vector(1:length(message))=message;
 message_vector=round(reshape(message,Mm*Nm,1)./256);
% read in key for PN generator
file_name='_key.bmp';
key=double(imread(file_name))./256;
 
% reset MATLAB's PN generator to state "key"
j = 1;
for i =1:length(key)
rand('state',key(i,j));
end
 
 
[cA1,cH1,cV1,cD1] = dwt2(cover_object,'haar');

 % add pn sequences to H1 and V1 componants when message = 0 
for (kk=1:length(message_vector))
    pn_sequence_h=round(2*(rand(Mc/2,Nc/2,Oc)-0.5));
    pn_sequence_v=round(2*(rand(Mc/2,Nc/2,Oc)-0.5));
    
    if (message(kk) == 0)
%         cH1(:,:,1)=cH1(:,:,1)+k*pn_sequence_h;
%         cV1(:,:,1)=cV1(:,:,1)+k*pn_sequence_v;
        cH1=cH1+k*pn_sequence_h;
        cV1=cV1+k*pn_sequence_v;
    end
end

watermarked_image = idwt2(cA1,cH1,cV1,cD1,'haar',[Mc,Nc]); 
 
% convert back to uint8
watermarked_image_uint8=uint8(watermarked_image);
 
 [message_vector,Mo,No] = dwtrecover(watermarked_image,k,message1);
 recmessage=reshape(message_vector,Mo,No);
 NCC=ncc(double(message1),recmessage);
% calculate the PSNR
I0     = double(cover_object);
I1     = double(watermarked_image_uint8);
Id     = (I0-I1);
signal = sum(sum(I0.^2));
noise  = sum(sum(Id.^2));
MSE  = noise./numel(I0);
peak = max(I0(:));
PSNR = 10*log10(peak^2/MSE(:,:,1));
% Image Fiedility
IF = imfed(I0,Id);
IF = mean(IF);

%Normalized Cross Correlation


watermrkd_img=watermarked_image_uint8;
close(h) 
end



