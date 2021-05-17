function [mark_I,Side_Info,room,num_S,Huffman_Info] = Huffman_Mark(PE_I,encrypt_I,dict,Pre_PE_op,Pre_PE_ne)
% ����˵�����Լ���ͼ��encrypt_I���б��
% ���룺PE_I��Ԥ����,encrypt_I������ͼ��,,pa_1,pa_2��������
% �����mark_I�����ͼ��,Side_Info��������Ϣ��,pe_min,pe_max����Ƕ��Ԥ����Χ��
% I = imread('����ͼ��\Lena.tiff');
% origin_I = double(I); 
% Image_key = 1;%ͼ�������Կ
% 
% 
% 
% % I = imread('����ͼ��\7003.pgm');
% % origin_I = double(I); 
% % Image_key = 1;%ͼ�������Կ
% 
% num = 10000000;
% D = round(rand(1,num)*1); %�����ȶ������
% Data_key = 2; %���ݼ�����Կ
% %��Ƕ����Ϣ����������
% num_available=0;
% [row,col] = size(origin_I); %����origin_I������ֵ
% %% ����origin_I��Ԥ�����
% [PE_I] = Predictor_Error(origin_I); 
% hist(PE_I(2:512,2:512),100);
% %% ��ԭʼͼ��origin_I���м���
% [encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  ����Ԥ������������������
[dict,Pre_PE_op,Pre_PE_ne]= Huffman(PE_I);
%[dict,PE_Pro]= Copy_of_Huffman(Pre_PE_op,Pre_PE_ne);
[m1,n1]=size(dict);


 room=0; %% �ճ��ռ�λ
 
% %% ����origin_I��Ԥ�����
% [PE_I] = Predictor_Error(origin_I); 
% %% ��ԭʼͼ��origin_I���м���
% [encrypt_I] = Encrypt_Image(origin_I,Image_key);
%%  ����Ԥ������������������
[dict,PE_Pro]= Huffman(PE_I);


[row,col] = size(encrypt_I); %����encrypt_I������ֵ
mark_I = encrypt_I;  %�����洢���ͼ�������
mark_I_fli= encrypt_I; %��ת��� 
[m1,n1]=size(dict);

%% ������
Huffman_Info = zeros(); %��¼Huffman������Ϣ
Side_Info = zeros(); %��¼������Ϣ
num_H = 16; %������ͳ�ƹ�����������Ϣ����
num_S = 0; %������ͳ�Ƹ�����Ϣ����
for q=1:m1
    if dict{q,1}>0
        %Ԥ��ֵ�Ķ�������ʽ
       temp=Decimalism_Binary(dict{q,1});
       %������־λ��1λ��
       Huffman_Info(num_H+1)=0;
       num_H = num_H+1;
       %Ԥ�����ֵ��6λ��
       Huffman_Info(num_H+1:num_H+6)=temp(3:8);
       num_H = num_H+6;
       %Huffman���볤�ȣ�4λ��
       L=length(dict{q,2});
       Len=Decimalism_Binary(L);
       Huffman_Info(num_H+1:num_H+4)=Len(5:8);
       num_H = num_H+4;
       %Huffman���루4λ��
       Value=Decimalism_Binary(dict{q,2});
       Huffman_Info(num_H+1:num_H+8)=Value(1:8);
       num_H = num_H+8;
    else
       temp=Decimalism_Binary(abs(dict{q,1}));
       %������־λ��1λ��
       Huffman_Info(num_H+1)=1;
       num_H = num_H+1;
       %Ԥ�����ֵ��6λ��
       Huffman_Info(num_H+1:num_H+6)=temp(3:8);
       num_H = num_H+6;
       %Huffman���볤�ȣ�4λ��
       L=length(dict{q,2});
       Len=Decimalism_Binary(L);
       Huffman_Info(num_H+1:num_H+4)=Len(5:8);
       num_H = num_H+4;
       %Huffman���루8λ��
       Value=Decimalism_Binary(dict{q,2});
       Huffman_Info(num_H+1:num_H+8)=Value(1:8);
       num_H = num_H+8;
    end
    
end
%% Huffman���볤��(16λ��ʾ)

L_Huffman = dec2bin(num_H-16)-'0';
if length(L_Huffman) < 16
    len = length(L_Huffman);
    B = L_Huffman;
    L_Huffman = zeros(1,16);
    for i=1:len
        L_Huffman(16-len+i) = B(i); %����16λǰ�油��0
    end 
end

Huffman_Info(1:16)= L_Huffman;


%% ��¼�ο�����ֵ��������Ϣ��200*8=1600λ
for t=1:200
    temp_value = Decimalism_Binary(mark_I(1,t));
    Side_Info(num_S+1:num_S+8)=temp_value(1:8);
    num_S = num_S+8;
end
%% ��Huffman�������Ƕ�뵽ԭ���Ĳο�����λ��(ǰ16λ�ǳ���)
num_t=0;
for p=1:200
if num_t+8<=num_H
    mark_temp = Decimalism_Binary(mark_I(1,p));
    mark_temp(1:8)=Huffman_Info(num_t+1:num_t+8);
    num_t=num_t+8;
    mark_I(1,p)=Binary_Decimalism(mark_temp);
else
    mark_temp = Decimalism_Binary(mark_I(1,p));
    mark_temp(1:num_H-num_t)=Huffman_Info(num_t+1:num_H);
    num_t=num_t+num_H-num_t;
    mark_I(1,p)=Binary_Decimalism(mark_temp);
end
end
%% ����Ԥ������ͼ����б��
for i=2:row
    for j=2:col
        pe = PE_I(i,j); %��ǰ���ص��Ԥ�����
        if pe<Pre_PE_ne || pe>Pre_PE_op %������Χ��Ԥ������һ����д���
           value = encrypt_I(i,j); %��ǰ��������ֵ
           [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������  
           %bin2_8 = fliplr(bin2_8); %% ��ת����ֵ
           mark=dict{1,2};%��Ӧ����������
           [bin_mark] = Decimalism_Binary(mark); %���mark��Ӧ��8λ�����Ʊ���
           [~,x1]=size(dict{1,2});
           %% ͬ����¼������Ϣ
           Side_Info(num_S+1:num_S+x1)=bin2_8(1:x1);
           num_S = num_S+x1;
           %% ��Huffman������
           bin2_8(1:x1) = bin_mark(8-x1+1:8);%���markֻ��x1���ر�ʾ
           %bin2_8 = fliplr(bin2_8); %% �����ط�ת����
           %% ������ת��ֻ�޸�LSB�������Ϳ�����PSNR
           %% 11000111-->11100011-->100 00011
           %% ԭʼ        ��ת��      ��Ǻ�      
           mark_I(i,j)=Binary_Decimalism(bin2_8); %��Ǻ�����ֵ
        else %% 
           value = encrypt_I(i,j); %��ǰ��������ֵ
           [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������ 
           %bin2_8 = fliplr(bin2_8); % ��ת����
           for c=1: m1
               if pe == dict{c,1}
                   mark=dict{c,2};
                   [bin_mark] = Decimalism_Binary(mark); %���mark��Ӧ��8λ������
                   [~,x2]=size(dict{c,2});
                   if x2==1
                       bin2_8(1) = bin_mark(8);%���markֻ��x2���ر�ʾ
                   else
                       bin2_8(1:x2) = bin_mark(8-x2+1:8);%���markֻ��x2���ر�ʾ
                   end
                   room=8-x2+room;
                   %bin2_8 = fliplr(bin2_8); %��ת����
                   mark_I(i,j)=Binary_Decimalism(bin2_8);
               end
           end
           
           
        end
            
%         value = encrypt_I(i,j); %��ǰ��������ֵ
%         [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
%         bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת                 %%%%%%%%%ΪʲôҪ��ת
%         if pe>=pe_min && pe<=pe_max  %��Ƕ��������أ���pa_1���ر��
%             mark = pe + dv; %mark��ʾ��Ǳ���ת��ʮ���Ƶ�ֵ
%             [bin_mark] = Decimalism_Binary(mark); %���mark��Ӧ��8λ������
%             bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%���markֻ��pa_1���ر�ʾ
%         else %����Ƕ�����أ���pa_2����ȫ0���
%             Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %��¼��������ֵ��ǰpa_2����MSB��Ϊ������Ϣ
%             num_S = num_S + pa_2;
%             for k=1:pa_2
%                 bin2_8(k) = 0;
%             end
%         end
%         bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
%         [value] = Binary_Decimalism(bin2_8); %����Ǻ�Ķ�����ת���ɱ������ֵ
%         mark_I(i,j) = value; %��¼������� 
    end
end
for r=1:row
    for c=1:col
        temp=mark_I(r,c);
        temp_2_8=Decimalism_Binary(temp);
        temp_fli=fliplr(temp_2_8);
        [value_temp] = Binary_Decimalism(temp_fli);
        mark_I_fli(r,c) = value_temp;
    end
end
%end