clear
clc
% I = imread('����ͼ��\Airplane.tiff');
 I = imread('����ͼ��\Lena.tiff'); %3.2618
% I = imread('����ͼ��\Man.tiff');  %2.8963
% I = imread('����ͼ��\Jetplane.tiff'); %3.6041
% I = imread('����ͼ��\Baboon.tiff'); %1.4808
% I = imread('����ͼ��\Tiffany.tiff'); %3.376
% I = imread('����ͼ��\Lake.tiff'); %2.4092
% I = imread('����ͼ��\Peppers.tiff'); %2.91
%I = imread('����ͼ��\7003.pgm');
% I=[152 153 152 152 153;149 152 151 147 155;153 151 151 149 153; 151 154 153 150 147;];
origin_I = double(I); 
%% ������������������
num = 10000000;
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ���ò���
Image_key = 1;%ͼ�������Կ
Data_key = 2; %���ݼ�����Կ
pa_1 = 5; %�����еĦ���������ǿ�Ƕ����bit��
pa_2 = 2; %�����еĦ£�������ǲ���Ƕ����bit��

%% ͼ����ܼ�����Ƕ��
[num_available,stego_I,encrypt_I,emD,num_emD,num_S,Huffman_Info,Pre_PE_op,Pre_PE_ne] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2);
K =[0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = 255;


disp('Encrypted image��PSNR��SSIMΪ��')
psnrencrypted = PSNR(origin_I,encrypt_I)
ssimVencrypted = SSIM(origin_I,encrypt_I, K, window, L) %% ��������

disp('Marked encrypted image��PSNR��SSIMΪ��')
ssimVmark = SSIM(origin_I,stego_I, K, window, L) %% ��������
psnrmark = PSNR(origin_I,stego_I) 

% imwrite(uint8(encrypt_I),'����ͼ��\���ܺ��Lena.tiff','tiff');
% imwrite(uint8(stego_I),'����ͼ��\����+���+���ܺ��Lena.tiff','tiff');

%% ������ȡ��ͼ��ָ�
[m,n] = size(origin_I);      
bpp = num_emD/(m*n)
if num_emD > 0  %��ʾ�пռ�Ƕ������
    %--------�ڼ��ܱ��ͼ������ȡ��Ϣ--------%
    %[Side_Info,Encrypt_exD,PE_I] = Extract_Data(stego_I,num_emD);
    [dict_re,ExD,num_Ext,Side_Info,PE_I_R] = Extract_Data(stego_I,num_emD,num_S);%PE_I_R�ǻָ��˲��ֵ�Ԥ�����
    
    %---------------��������----------------%
    [exD] = Encrypt_Data(ExD,Data_key);
   
   
%     %---------------ͼ��ָ�----------------%
     [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I_R,dict_re,Pre_PE_op,Pre_PE_ne);
     
    %---------------ͼ��Ա�----------------%
    figure;
    subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
    subplot(222);imshow(encrypt_I,[]);title('����ͼ��');
    subplot(223);imshow(stego_I,[]);title('����ͼ��');
    subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
    
    % A=Flip_stego_I;
% % get the histogram 
% 
% grayvalue=unique(A);
% imginfo=[];
% for i=1:length(grayvalue)
%         [ANSy,ANSx]=find(A==grayvalue(i));
%         imginfo.gray(i)=grayvalue(i);
%         imginfo.position{i}=[ANSy,ANSx];
%         imginfo.count(i)=length(ANSy);
% end
% %subplot(1,2,1);
% figure;
% imshow(A);
% title('Original Image');
% %subplot(1,2,2);
% figure;
% stem(imginfo.gray,imginfo.count,'Marker','none');
% %xlabel('Graylevel');
% %ylabel('Proportion');
% axis([0 255 0 3000]);
% title('Histogram of the orginial image')
    
    %---------------����ж�----------------%
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
    if check1 == 1
        disp('��ȡ������Ƕ��������ȫ��ͬ��')
    else
        disp('Warning��������ȡ����')
    end
    if check2 == 1
        disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
    else
        disp('Warning��ͼ���ع�����')
    end
    %---------------������----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD)])
        disp(['Embedding rate equal to : ' num2str(bpp)])
        fprintf(['�ò���ͼ��------------ OK','\n\n']);
    else
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end
else
    disp('������Ϣ������Ƕ�����������޷��洢���ݣ�') 
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end

