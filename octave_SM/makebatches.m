% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

%fprintf(1, 'Leyendo Test Data \n');
%fileID = fopen('../Datasets/20news-bydate/20news-bydate-test/word_count','r');
%formatSpec = '%d';
%sizeA = [3 Inf];
%text_data=fscanf(fileID,formatSpec,sizeA); %Cada Columna contiene el id del texto, id de la palabra y su frecuencia.
%test_data = [];
%for td=1:(size(text_data,2)-1)
%	fprintf(1,'palabra %d/%d \r',td,size(text_data,2)-1);
%	test_data(text_data(1,td),text_data(2,td))=text_data(3,td);
%end;

load Matlab/tf_test.mat
test_data=tf;
test_label=label;

totnum=size(test_data,1);
fprintf(1, 'Tamaño Testing Dataset = %5d \n', totnum);
batchsize = 10;
numbatches=floor(totnum/batchsize)
numdims = size(test_data,2);
testbatchdata = zeros(batchsize, numdims, numbatches);
testbatchtargets = zeros(batchsize,numbatches);
for b=1:numbatches
  fprintf(1,'Batch %d/%d \r',b,numbatches);
  testbatchdata(:,:,b) = test_data(1+(b-1)*batchsize:b*batchsize,:);
  testbatchtargets(:,b) = test_label(1+(b-1)*batchsize:b*batchsize);
end;

clear test_data test_label

fprintf(1, 'Leyendo Training Data \n');
%fileID = fopen('../Datasets/20news-bydate/20news-bydate-train/word_count','r');
%formatSpec = '%d';
%sizeA = [3 Inf];
%text_data=fscanf(fileID,formatSpec,sizeA); %Cada Columna contiene el id del texto, id de la palabra y su frecuencia.
%train_data = [];
%for td=1:(size(text_data,2)-1)
	%fprintf(1,'palabra %d/%d \r',td,size(text_data,2)-1);
	%train_data(text_data(1,td),text_data(2,td))=text_data(3,td);
%end;

load Matlab/tf_train.mat
train_data=tf;
train_label=label;

totnum=size(train_data,1);
fprintf(1, 'Tamaño training Dataset = %5d \n', totnum);
batchsize = 100;
numbatches=floor(totnum/batchsize)
numdims  =  size(train_data,2);
#numdims  = text_data(1,size(text_data,2));
batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize,numbatches);
for b=1:numbatches
  fprintf(1,'Batch %d/%d \r',b,numbatches);
  batchdata(:,:,b) = train_data(1+(b-1)*batchsize:b*batchsize,:);
  batchtargets(:,b) = train_label(1+(b-1)*batchsize:b*batchsize);
end;

clear train_data train_label

%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 