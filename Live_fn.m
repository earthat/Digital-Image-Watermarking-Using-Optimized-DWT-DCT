
function [fposition,watermrkd_img,recmessage,PSNR,IF,NCC]=Live_fn(x,cover_object,message)
k1=x(1);
k2=x(2);
k3=x(3);
k4=x(4);
[PSNR,IF,NCC,NCC1,NCC2,NCC3,NCC4,watermrkd_img,recmessage]=embed(k1,k2,k3,k4,cover_object,message);
fposition=1/(NCC1+NCC2+NCC3+NCC4);
end

