clear
clc
%% ������������������
num = 10000000;
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ͼ�����ݼ���Ϣ(BOSSbase_1.01),��ʽ:PGM,����:10000��
I_file_path = 'D:\ImageDatabase\BossBase-1.01\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.pgm'));  %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ���Ƕ������Ƕ����
num_BOSSbase = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ���� 
bpp_BOSSbase = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ����
%% ���ò���
Image_key = 1;%ͼ�������Կ
Data_key = 2; %���ݼ�����Կ
pa_1 = 5; %�����еĦ���������ǿ�Ƕ����bit��
pa_2 = 2; %�����еĦ£�������ǲ���Ƕ����bit��
%% ͼ�����ݼ�����
for i=1: img_num%5
    %----------------��ȡͼ��----------------%
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);
   %---------------%% ͼ����ܼ�����Ƕ��----------------%
   %[stego_I,encrypt_I,emD,num_emD,num_S] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2);
   
    [num_available,stego_I,encrypt_I,emD,num_emD,num_S,Huffman_Info,Pre_PE_op,Pre_PE_ne] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2);
    
    if num_emD > 0
        %--------�ڼ��ܱ��ͼ������ȡ��Ϣ--------%
        %[dict_re,ExD,num_Ext,Side_Info,PE_I_R] = Extract_Data(stego_I,num_emD,num_S);
%          [dict_re,ExD,num_Ext,Side_Info,PE_I_R] = Extract_Data(stego_I,num_emD,num_S,Pre_PE_op,Pre_PE_ne);
% 
%         %---------------��������----------------%
%         [exD] = Encrypt_Data(ExD,Data_key);
%         %---------------ͼ��ָ�----------------%
%         %[recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I_R,dict_re);
%          [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I_R,dict_re,Pre_PE_op,Pre_PE_ne);
% 
%         %---------------�����¼----------------%
        [m,n] = size(origin_I);
        num_BOSSbase(i) = num_emD;
        bpp_BOSSbase(i) = num_emD/(m*n);
%         %---------------����ж�----------------%
%         check1 = isequal(emD,exD);
%         check2 = isequal(origin_I,recover_I);
%         if check1 == 1  
%             disp('��ȡ������Ƕ��������ȫ��ͬ��')
%         else
%             disp('Warning��������ȡ����')
%         end
%         if check2 == 1
%             disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
%         else
%             disp('Warning��ͼ���ع�����')
%         end
%         %---------------������----------------%
%         if check1 == 1 && check2 == 1
            bpp = bpp_BOSSbase(i);
            disp(['Embedding capacity equal to : ' num2str(num_emD)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
%         else
%             if check1 ~= 1 && check2 == 1
%                 bpp_BOSSbase(i) = -2; %��ʾ��ȡ���ݲ���ȷ
%             elseif check1 == 1 && check2 ~= 1
%                 bpp_BOSSbase(i) = -3; %��ʾͼ��ָ�����ȷ
%             else
%                 bpp_BOSSbase(i) = -4; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
%             end
%             fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
%         end  
    else
        num_BOSSbase(i) = -1; %��ʾ����Ƕ����Ϣ  
        disp('������Ϣ������Ƕ�����������޷��洢���ݣ�') 
        fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    end
end
%% ��������
%save('num_BOSSbase_Huffman')
save('bpp_BOSSbase_Huffman_1')