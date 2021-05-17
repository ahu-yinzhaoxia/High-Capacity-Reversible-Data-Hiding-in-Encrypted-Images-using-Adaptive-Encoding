function [num_available,stego_I,encrypt_I,emD,num_emD,num_S,Huffman_Info,Pre_PE_op,Pre_PE_ne] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2)
% ����˵������ԭʼͼ��origin_I���ܲ�Ƕ������
% ���룺origin_I��ԭʼͼ��,Image_key��ͼ�������Կ��,D���������ݣ�,Data_key(���ݼ�����Կ),pa_1,pa_2��������
% �����stego_I������ͼ��,encrypt_I������ͼ��,emD��Ƕ����������ݣ�,num_emD��Ƕ���������ݵĸ�����
% I = imread('����ͼ��\Lena.tiff');
% origin_I = double(I); 
% Image_key = 1;%ͼ�������Կ
% num = 10000000;
% D = round(rand(1,num)*1); %�����ȶ������
% Data_key = 2; %���ݼ�����Կ
%��Ƕ����Ϣ����������
num_available=0;
[row,col] = size(origin_I); %����origin_I������ֵ
%% ����origin_I��Ԥ�����
[PE_I] = Predictor_Error(origin_I); 
hist(PE_I(2:512,2:512),100);
%% ��ԭʼͼ��origin_I���м���
[encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  ����Ԥ������������������
[dict,Pre_PE_op,Pre_PE_ne]= Huffman(PE_I);
%[dict,PE_Pro]= Copy_of_Huffman(Pre_PE_op,Pre_PE_ne);
[m1,n1]=size(dict);

%% �Լ���ͼ��encrypt_I����Huffman���
[mark_I,Side_Info,room,num_S,Huffman_Info] = Huffman_Mark(PE_I,encrypt_I,dict,Pre_PE_op,Pre_PE_ne);
% %% �Լ���ͼ��encrypt_I���б��
% [mark_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(PE_I,encrypt_I,pa_1,pa_2);

% K =[0.01 0.03];
% window = fspecial('gaussian', 11, 1.5);
% L = 255;
% disp('Encrypted image with label��PSNR��SSIMΪ��')
% psnrmark = PSNR(origin_I,mark_I) 
% ssimVmark = SSIM(origin_I,mark_I, K, window, L) %% ��������


%imwrite(uint8(mark_I),'����ͼ��\����+��ǵ�Lena.png','png');
%% ��ԭʼ������ϢD���м���
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% ������
num_D = length(Encrypt_D); %��������ϢD�ĳ���
num_emD = 0; %������ͳ��Ƕ��������Ϣ�ĸ���
num_S = length(Side_Info); %������ϢSide_Info�ĳ���
num_side = 0; %��������¼Ƕ�븨����Ϣ�ĸ���



    
%% �ڱ��ͼ����Ƕ����Ϣ
stego_I = mark_I;  %�����洢����ͼ�������
for i=2:row
    for j=2:col 
        if num_emD >= num_D %����������Ƕ�����
            break;
        end
        pe = PE_I(i,j); %��ǰ���ص��Ԥ�����
        value = mark_I(i,j); %��ǰ�������ֵ
        [bin2_8] = Decimalism_Binary(value); %��ǰ�������ֵ��Ӧ��8λ������
        %bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
        if pe<Pre_PE_ne || pe>Pre_PE_op %����Ƕ��� 
            %bin2_8 = fliplr(bin2_8); %��bin2_8��ת���� 
            [value] = Binary_Decimalism(bin2_8);
            stego_I(i,j) = value; 
            
        else %��Ƕ��������أ���Ƕ��(8-x2)����
            num_available=num_available+1;
            for c=1: m1     %������x2
                   if pe == dict{c,1}
                   [~,x2]=size(dict{c,2});
                   end
            end
            
            if num_side < num_S %������Ϣû��Ƕ��
              
                if num_side+8-x2 <= num_S %(8-x2)���ض�����Ƕ�븨����Ϣ
                    bin2_8(x2+1:8) = Side_Info(num_side+1:num_side+8-x2);
                    num_side = num_side + 8-x2;
                    %bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻tλLSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(x2+1:x2+t) = Side_Info(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(x2+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-x2-t); %(8-x2-t)bit��������
                    num_emD = num_emD + 8-x2-t;
                    %bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻tλLSB
                end
            else %������ϢǶ��֮����Ƕ����������
                if num_emD+8-x2 <= num_D %(8-pa_1)���ض�����Ƕ����������
                    bin2_8(x2+1:8) = Encrypt_D(num_emD+1:num_emD+8-x2);
                    num_emD = num_emD + 8-x2;
                    %bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻tλLSB
                else
                    t = num_D - num_emD; %ʣ���������ݸ���
                    bin2_8(x2+1:x2+t) = Encrypt_D(num_emD+1:num_D); %tbit��������
                    num_emD = num_emD + t;
                    %bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻tλLSB
                end
            end
        end      
    end
end
%% ͳ��Ƕ�����������
if num_side == num_S %��ʾ������ϢǶ�����
    emD = D(1:num_emD);
else %��ศ����Ϣ�������޷�Ƕ����������
    emD = zeros();
    num_emD = num_side - num_S;
end
