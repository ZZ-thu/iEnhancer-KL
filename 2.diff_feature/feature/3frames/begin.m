clear all
data=read_data("data.txt");
%% fixed parameter 
lambda=2;
w=0.5;
a=0.2;
b=0.5;
%% input parameter 
% lambda=input('lambda=');
% w=input('w=');
% a=input('a= ,0<a<1');
% b=input('b= ,a<b<1');
%% function
t_m=tri_mer(data);
t_p=tri_pseKNC(data,a,b,lambda,w);
p=pseKNC(data,lambda,w); 
save t_m t_m
save t_p t_p
save pseKNC p