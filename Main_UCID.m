clear
clc
%% ������������������
num = 10000000;
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ͼ�����ݼ���Ϣ(ucid.v2),��ʽ:TIFF,����:1338��
I_file_path = 'D:\ImageDatabase\ucid.v2\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.tif')); %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ���Ƕ������Ƕ����
num_UCID = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ���� 
bpp_UCID = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ����
%% ���ò���
Image_key = 1;%ͼ�������Կ
Data_key = 2; %���ݼ�����Կ
pa_1 = 5; %�����еĦ���������ǿ�Ƕ����bit��
pa_2 = 2; %�����еĦ£�������ǲ���Ƕ����bit��
%% ͼ�����ݼ�����
for i=1:img_num%10 
    %----------------��ȡͼ��----------------%
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);
    %---------------%% ͼ����ܼ�����Ƕ��----------------%
    [stego_I,encrypt_I,emD,num_emD,num_S,Huffman_Info,Pre_PE_op,Pre_PE_ne] = Encrypt_Embed(origin_I,Image_key,D,Data_key,pa_1,pa_2);
    
    if num_emD > 0  
        %--------�ڼ��ܱ��ͼ������ȡ��Ϣ--------%
%         [dict_re,ExD,num_Ext,Side_Info,PE_I_R] = Extract_Data(stego_I,num_emD,num_S);%PE_I_R�ǻָ��˲��ֵ�Ԥ�����
%         %---------------��������----------------%
%         [exD] = Encrypt_Data(ExD,Data_key);
%         %---------------ͼ��ָ�----------------%
%         [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I_R,dict_re,Pre_PE_op,Pre_PE_ne);
%         %---------------�����¼----------------%
        [m,n] = size(origin_I);
%         num_UCID(i) = num_emD;
        bpp_UCID(i) = num_emD/(m*n);
        %---------------����ж�----------------%
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
        %---------------������----------------%
%         if check1 == 1 && check2 == 1
            bpp = bpp_UCID(i);
%             disp(['Embedding capacity equal to : ' num2str(num_emD)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
%         else
%             if check1 ~= 1 && check2 == 1
%                 bpp_UCID(i) = -2; %��ʾ��ȡ���ݲ���ȷ
%             elseif check1 == 1 && check2 ~= 1
%                 bpp_UCID(i) = -3; %��ʾͼ��ָ�����ȷ
%             else
%                 bpp_UCID(i) = -4; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
%             end
%             fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
%         end  
%     else
%         num_UCID(i) = -1; %��ʾ����Ƕ����Ϣ  
%         disp('������Ϣ������Ƕ�����������޷��洢���ݣ�') 
%         fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    end
end
%% ��������
% save('num_UCID_Huffman')
save('bpp_UCID_Huffman_2')