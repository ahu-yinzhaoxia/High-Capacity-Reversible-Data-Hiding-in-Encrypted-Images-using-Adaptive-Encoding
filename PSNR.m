function PSNR=PSNR(Img1,Img2)
%�������ܣ��鿴������
%�������룺��ͼ������ֵ
%���������������
Img1=double(Img1(:));  %������ת��Ϊdouble��
Img2=double(Img2(:)); 
MSE=sum((Img1-Img2).*(Img1-Img2))/numel(Img1); %�������
if MSE==0
    fprintf('MSE = 0\n');
    PSNR=-1;
else
    PSNR=10*log10(255*255/MSE);
end