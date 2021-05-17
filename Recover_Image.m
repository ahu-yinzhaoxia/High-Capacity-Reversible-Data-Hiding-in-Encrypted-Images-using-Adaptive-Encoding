function [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I,dict_re,Pre_PE_op,Pre_PE_ne)
% ����˵����������ȡ�ĸ�����Ϣ����Կ�ָ�ͼ��
% ���룺stego_I������ͼ��,Image_key��ͼ�������Կ��,Side_Info��������Ϣ��,PE_I��Ԥ����,pa_1,pa_2��������
% �����recover_I���ָ�ͼ��
%% ������
[row,col] = size(stego_I); %ͳ��stego_I��������
num_side = 0; %��������¼������Ϣ�ĸ���
trans_I=stego_I;

%% �ָ��ο�����ֵ
for k=1:8:1600
    trans_I(1,floor(k/8)+1)=Binary_Decimalism(Side_Info(k:k+7));
end
%% �ָ�����Ƕ����Ϣֵ
Side_num=1600;%ǰ800λ�ǲο�����ֵ
for i1=2:row
    for j1=2:col
       value = stego_I(i1,j1); %��ǰ��������ֵ 
       [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
       %bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
       [~,x1]=size(dict_re{1,2});
       if bin2_8(1:x1)== dict_re{1,2} %Ѱ�ұ�Ƕ�ӦHuffman����
           PE_I(i1,j1)=31;
           bin2_8(1:x1)=Side_Info(Side_num+1:Side_num+x1);%�ָ�ֵ
           Side_num=Side_num+x1;
           trans_I(i1,j1)=Binary_Decimalism(bin2_8);
       end
    end
end


% %% �ָ��������ص��ֵ
% trans_I = stego_I; %�������ָֻ��Ĺ���ͼ��
% bin2_8 = Side_Info(num_side+1:num_side+8); %����������Ϊ8λ������Ϣ
% num_side = num_side + 8;
% [value] = Binary_Decimalism(bin2_8); %��8λ������ת������������ֵ
% trans_I(1,1) = value;
% %% �ָ�����Ƕ���ı��λ
% for i=2:row
%     for j=2:col
%         pe = PE_I(i,j); %��ǰ���ص��Ԥ�����
%         if pe>=pe_min && pe<=pe_max  %��Ƕ���
%             continue;
%         else %����Ƕ��㣬�滻ǰpa_2λ���ֵ
%             value = trans_I(i,j); %��ǰ��������ֵ
%             [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
%             bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
%             bin2_8(1:pa_2) = Side_Info(num_side+1:num_side+pa_2);
%             num_side = num_side + pa_2;
%             bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
%             [value] = Binary_Decimalism(bin2_8); %���滻���8λ������ת��������ֵ
%             trans_I(i,j) = value;
%         end   
%     end
% end
%% ��ͼ��trans_I���н��ܣ��ָ�ͼ��ʹ��PE_I��
[decrypt_I] = Encrypt_Image(trans_I,Image_key);

%% �ָ���Ƕ��������ֵ
recover_I = decrypt_I;
%subplot(111);imshow(recover_I,[]);title('�ָ�ͼ��');
for i=2:row
    for j=2:col
        pe = PE_I(i,j); %��ǰ���ص��Ԥ�����
        if pe>=Pre_PE_ne && pe<=Pre_PE_op  %��Ƕ���
            %--����Ԥ��ֵ���ٸ���Ԥ�����ָ�����ֵ--%
            a = recover_I(i-1,j);
            b = recover_I(i-1,j-1);
            c = recover_I(i,j-1);
            if b <= min(a,c)
                pv = max(a,c);
            elseif b >= max(a,c)
                pv = min(a,c);
            else
                pv = a + c - b;
            end
            recover_I(i,j) = pv + pe;
        else %����Ƕ���
            continue;
        end   
    end
end
end