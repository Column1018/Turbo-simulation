function [lstate,nstate,lparoutput]=gen_trellis(g)

[~,K] = size(g);
m = K - 1;              % �Ĵ�������
nstate=zeros(2,2^m);    % Ԥ�ȷ����ٶ�
lstate=zeros(2,2^m); 
lparoutput=zeros(2,2^m); 
for i=1:2^m
    state_temp=de2bi(i-1,m); % ʮ����ת������
    
    %input 0
    state=fliplr(state_temp); % state, corresponding to decimal value  1,2,...,2^m
    in=xor(rem(g(1,2:end)*state',2),0); % input 0
    paroutput=rem(g(2,:)*[in state]',2);
    state=[in,state(1:m-1)];
    nstate_index=bi2de(fliplr(state))+1;      % ������ת����ʮ����
    nstate(1,i)=nstate_index;                 % ��һ��״̬
    lparoutput(1,nstate_index)=2*paroutput-1; % ��һ����żУ�����
    lstate(1,nstate_index)=i;                 % ��һ��״̬
    
    %input 1
    state=fliplr(state_temp);
    in=xor(rem(g(1,2:end)*state',2),1);
    paroutput=rem(g(2,:)*[in state]',2);
    state=[in,state(1:m-1)];
    nstate_index=bi2de(fliplr(state))+1;
    nstate(2,i)=nstate_index; 
    lparoutput(2,nstate_index)=2*paroutput-1;
    lstate(2,nstate_index)=i; 
end