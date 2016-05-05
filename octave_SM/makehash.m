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

fprintf(1,'\nGenerar Hash para dataset \n');

%%%% CARGAR PESOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load Matlab/weights.mat

%%%% GENERAR BATCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makebatches;
[numcases numdims numbatches]=size(batchdata);
N=numcases; 


%%%%%%%%%%%%%%%%%%%% GENERAR HASH TRAINING DATA DE RED YA ENTRENADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Generar Hash Training Data \n');
[numcases numdims numbatches]=size(batchdata);
N=numcases;
hash_train  = [];
label_train = [];
 for batch = 1:numbatches
  fprintf(1,'Batches %d/%d \r',batch,numbatches);
  data = [batchdata(:,:,batch)];
  data = [data ones(N,1)];  
  w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
  w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
  w3probs = 1./(1 + exp(-w2probs*w3)); w3probs = [w3probs  ones(N,1)];
  w4probs = w3probs*w4; w4probs = w4probs > 0.1; % w4probs = [w4probs  ones(N,1)];
  hash_train = [hash_train;w4probs];
  label_train = [label_train;batchtargets(:,batch)];
  end
fprintf(1,'Hash Training Data generado \n');

%%%%%%%%%%%%%%%%%%%% GENERAR HASH TEST DATA DE RED YA ENTRENADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Generar Hash Test Data \n');
[testnumcases testnumdims testnumbatches]=size(testbatchdata);
N=testnumcases;
hash_test = [];
label_test = [];
for batch = 1:testnumbatches
  fprintf(1,'Batches %d/%d \r',batch,testnumbatches);
  data = [testbatchdata(:,:,batch)];
  data = [data ones(N,1)];
  w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
  w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
  w3probs = 1./(1 + exp(-w2probs*w3)); w3probs = [w3probs  ones(N,1)];
  w4probs = w3probs*w4; w4probs = w4probs > 0.1; % w4probs = [w4probs  ones(N,1)];
  hash_test = [hash_test;w4probs];
  label_test = [label_test;testbatchtargets(:,batch)];
  end
fprintf(1,'Hash Test Data generado \n');

fprintf(1,'Guardar hash generados para test y training \n');

save -6 Matlab/hash_test.mat hash_test 
save -6 Matlab/hash_train.mat hash_train 

fprintf(1,'Compactbit \n');

traincompacthash = compactbit(hash_train);
testcompacthash = compactbit(hash_test);

fprintf(1,'Distancia de Hamming \n');
%Dhamm_test_train = hammingDist(testcompacthash, traincompacthash);
Dhamm_test_train = hammingDist(testcompacthash, testcompacthash);

fprintf(1,'Obtener Precision y Recall \n');
tic
%[precision, recall] = evaluation_r(label_test, label_train, Dhamm_test_train,4);
[precision, recall] = evaluation_r(label_test, label_test, Dhamm_test_train,4);
toc

fprintf(1,'Precision %f \n',sum(precision)/size(precision,1));
fprintf(1,'Recall %f \n',sum(recall)/size(recall,1));
fprintf(1,'Guardar Precision y Recall en archivo results.mat \n');
save -6 Matlab/results.mat precision recall