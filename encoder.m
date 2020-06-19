function en_output = encoder( x, g, alpha, ispuncture )
%Turbo encoder (2,1,K)RSC
%Random interleaver
%Input:
% x           --�������������
% alpha       --�����֯��
% ispuncture  --1 punctured,  rate 1/2 output
%             --0 unpunctured,rate 1/3 output
% ��·��������RSC1��ѡ������У��λ����RSC2��ѡ��ż��У��λ
% ȷ��Լ������(K)���Ĵ�����Ŀ(m)����Ϣλ��βλ������
% g:���ɶ���ʽ

[~,K] = size(g);
m = K - 1;  
L_info = length(x);
L_total = L_info + m;  

% ���ɶ�Ӧ��RSC������1������
% ��ȫ��ֹ
output1 = zeros(1,L_total);
input = [x zeros(1,m)];
state1 = zeros(1,m);
for i=1:L_info
    in1 = xor(rem(g(1,2:end)*state1',2),input(i)); %mode 2 plus
    output1(i) = rem(g(2,:)*[in1 state1]',2);
    state1 = [in1,state1(1:m-1)];
end
for i=L_info+1:L_total                     % ��ֹ����
    input(i) = rem(g(1,2:end)*state1',2);
    output1(i) = rem(g(2,:)*[0 state1]',2);
    state1 = [0,state1(1:m-1)];
end

% ��֯���뵽RSC������2
input2 = input(alpha);
 
% ���ɶ�Ӧ��RSC������2������
% δ��ֹ
output2 = zeros(1,L_total); 
state2 = zeros(1,m);
for i=1:L_total
    in2 = xor(rem(g(1,2:end)*state2',2),input2(i)); % mode 2 plus
    output2(i) = rem(g(2,:)*[in2 state2]',2);
    state2 = [in2,state2(1:m-1)];
end

%puncture or not
% ����ת���ж�·�����Ի�����ʸ��
if ispuncture ==0		     % δ���ף�rate=1/3
    output_t = zeros(1,3*L_total); 
    for i = 1:L_total
        output_t(3*(i-1)+1) = input(i);
        output_t(3*(i-1)+2) = output1(i);
        output_t(3*(i-1)+3) = output2(i);
    end
else		                 % ����, rate=1/2
    output_t = zeros(1,2*L_total); 
    for i=1:L_total
        output_t(2*(i-1)+1) = input(i);
        if rem(i,2)           %���Ե�һ��RSC������У��λ
            output_t(2*(i-1)+2) = output1(i);
        else                  %���Եڶ���RSC��ż��У��λ
            output_t(2*(i-1)+2) = output2(i);
        end
    end
end

% en_output=output_t; %for test
 
 % �����Ե��ƣ�+1/-1
en_output = 2*output_t-ones(size(output_t));
