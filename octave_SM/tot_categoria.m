function [y] = tot_categoria(x)

% Esta funcion retorna la ocurrencia de cada elemento en un arreglo ordenado.
% Input:
%	x: Arreglo
%
% Output
%	y: Ocurrencia de los elementos, es de largo igual al último elemento de x.
%

i=1;
j=1;
y=zeros(x(end),1);
%while i<=length(x)
for i=1:length(x)
	y(i)=sum(x==x(i));
	%i=i+y(j);
	%j=j+1;
end