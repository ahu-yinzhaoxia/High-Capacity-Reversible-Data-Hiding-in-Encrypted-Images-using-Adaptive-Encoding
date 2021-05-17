%function [Side_Info,Encrypt_exD,PE_I] = Extract_Data(stego_I,num_emD)
function [dict_re,ExD,num_Ext,Side_Info,PE_I] = Extract_Data(stego_I,num_emD,num_S,Pre_PE_op,Pre_PE_ne)
% ����˵�����ڼ��ܱ��ͼ������ȡ��Ϣ
% ���룺stego_I�����ܱ��ͼ��,num_emD��������Ϣ�ĳ��ȣ�
% �����Side_Info��������Ϣ��,Encrypt_exD�����ܵ�������Ϣ��,PE_I��Ԥ����,pa_1,pa_2��������


%% ������
[row,col] = size(stego_I); %ͳ��stego_I��������
PE_I = stego_I;
%% �ڲο�����λ�ô���ȡHuffman����
Huffman_Info=zeros();
Huffman_Length=zeros();
num_Huffman=0;
L=0;
%% ��Huffman�������
Huffman_Length(1:8)= Decimalism_Binary(stego_I(1,1));
Huffman_Length(9:16)= Decimalism_Binary(stego_I(1,2));

len = length(Huffman_Length);
for i=1:len
    L = L + Huffman_Length(i)*(2^(len-i));
end
%% ��ȡHuffman�����,������Ϣ�洢��Huffman_Info��
for t=3:200
    if num_Huffman+8<=L %Huffman�����δ��ȡ��
        Temp=Decimalism_Binary(stego_I(1,t));
        Huffman_Info(num_Huffman+1:num_Huffman+8)=Temp(1:8);
        num_Huffman=num_Huffman+8;
    else
        x=L-num_Huffman;
        Temp=Decimalism_Binary(stego_I(1,t));
        Huffman_Info(num_Huffman+1:num_Huffman+x)=Temp(1:x);
        num_Huffman=num_Huffman+x;
    end
end
%% ��Huffman_Info����Ϣ���룬�õ�dict_re��5��Ԥ�����ֵ 4��Huffman���볤�� 8��Huffman��
dict_re=cell(0);
for q=1:19:num_Huffman
    if Huffman_Info(q)== 0 %PEΪ��ֵ
        PE=Binary_Decimalism(Huffman_Info(q+1:q+6));
        Len=Binary_Decimalism(Huffman_Info(q+7:q+10)); %���볤��
        Mark=Huffman_Info(q+11:q+18);
        dict_re{floor(q/19)+1,1}=PE;
        dict_re{floor(q/19)+1,2}=Mark(8-Len+1:8);
    else
        PE=Binary_Decimalism(Huffman_Info(q+1:q+6))-2*(Binary_Decimalism(Huffman_Info(q+1:q+6)));
        Len=Binary_Decimalism(Huffman_Info(q+7:q+10)); %���볤��
        Mark=Huffman_Info(q+11:q+18);
        dict_re{floor(q/19)+1,1}=PE;
        dict_re{floor(q/19)+1,2}=Mark(8-Len+1:8);
    end
end
 [m1,n1]=size(dict_re);
%% ��ȡǶ�����Ϣ
Ext_Info=zeros();%��ȡ��Ϣ
Num_Ext=0; %��ȡ��Ϣ����
for i=2:row
    for j=2:col
       value = stego_I(i,j); %��ǰ��������ֵ 
       [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
       %bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
       for d=2:m1
           
               [~,x2]=size(dict_re{d,2});
               if bin2_8(1:x2)== dict_re{d,2} %Ѱ�ұ�Ƕ�ӦHuffman����
                   PE_I(i,j) = dict_re{d,1};
                   Ext_Info(Num_Ext+1:Num_Ext+8-x2)=bin2_8(x2+1:8);% ��ȡ��Ϣ
                   Num_Ext=Num_Ext+8-x2; %��¼��ȡ��Ϣ����
               end
           
       end
    end
end
Side_Info=zeros();    %������Ϣ
ExD=zeros();          %��Ƕ����Ϣ
Side_Info(1:num_S)=Ext_Info(1:num_S);  %Ƕ��ĸ�����Ϣ
num_Ext=Num_Ext-num_S;     %��Ƕ����Ϣ����
ExD(1:num_Ext)=Ext_Info(num_S+1:Num_Ext);
% %% �ָ��ο�����ֵ
% for k=1:8:100
%     stego_I(1,floor(k/8)+1)=Binary_Decimalism(Side_Info(k:k+7));
% end
% %% �ָ�����Ƕ����Ϣֵ
% Side_num=800;%ǰ800λ�ǲο�����ֵ
% for i1=2:row
%     for j1=2:col
%        value = stego_I(i1,j1); %��ǰ��������ֵ 
%        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
%        %bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
%        [~,x1]=size(dict_re{1,2});
%        if bin2_8(1:x1)== dict_re{1,2} %Ѱ�ұ�Ƕ�ӦHuffman����
%            PE_I(i1,j1)=15;
%            bin2_8(1:x1)=Side_Info(Side_num+1:Side_num+x1);%�ָ�ֵ
%            Side_num=Side_num+x1;
%        end
%     end
% end
% %% ��ȡǶ�����Ϣ
% for i=2:row
%     for j=2:col
%         sign = 0; %�����Ϣ���ж���Ƕ��㻹�ǲ���Ƕ���
%         value = stego_I(i,j); %��ǰ��������ֵ
%         [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
%         bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
%         for k=1:pa_2
%             if bin2_8(k) ~= 0
%                 sign = 1; %��ʾǰpa_2λ��ȫΪ0����Ϊ��Ƕ���
%             end
%         end
%         if sign == 1 %��Ƕ���
%             bin_mark = bin2_8(1:pa_1); %��ȡ���ֵ
%             [mark] = Binary_Decimalism(bin_mark); %�������ת����ʮ����
%             PE_I(i,j) = mark - dv; %Ԥ���������ֵ���dv
%             Info(t+1:t+8-pa_1) = bin2_8(pa_1+1:8); %���λ֮��ļ�ΪǶ�����Ϣ
%             t = t + 8-pa_1;
%         else %����Ƕ���
%             num_side = num_side + pa_2; %ǰpa_2λ��Ϊ������Ϣ
%             PE_I(i,j) = pe_min - 1; %����������ΪǶ��Ԥ��Χ֮��
%         end 
%     end
% end
% %% ��¼������Ϣ�ͼ��ܵ���������
% num_side = num_side + 8; %��������8λҲ��Ϊ������Ϣ
% Side_Info = Info(1:num_side);
% Encrypt_exD = Info(num_side+1:num_side+num_emD);
% end