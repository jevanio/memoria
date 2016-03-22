% Version 1.000 
%
% Code provided by Geoff Hinton and Ruslan Salakhutdinov 
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

% This program trains Restricted Boltzmann Machine in which
% visible, binary, stochastic pixels are connected to
% hidden, binary, stochastic feature detectors using symmetrically
% weighted connections. Learning is done with 1-step Contrastive Divergence.   
% The program assumes that the following variables are set externally:
% maxepoch  -- maximum number of epochs
% numhid    -- number of hidden units 
% batchdata -- the data that is divided into batches (numcases numdims numbatches)
% restart   -- set to 1 if learning starts from beginning 

epsilonw      = 0.01;   % Learning rate for weights 
epsilonvb     = 0.01;   % Learning rate for biases of visible units 
epsilonhb     = 0.01;   % Learning rate for biases of hidden units 
weightcost  = 0.0002;   
momentum    = 0.9;
errsum = [];
errsum1 = [];
errsum3 = [];
errsum3 = [];

[numcases numdims numbatches]=size(batchdata);

if restart ==1,
  restart=0;
  epoch=1;

% Initializing symmetric weights and biases. 
  %vishid     = normrnd(0,0.01,[numdims, numhid]);
  %vishid = vishid - repmat(sum(vishid,1)/size(vishid,1),size(vishid,1),1);
  vishid     = 0.1*randn(numdims, numhid);

  hidbiases  = zeros(1,numhid);
  visbiases  = zeros(1,numdims);

  poshidprobs = zeros(numcases,numhid);
  neghidprobs = zeros(numcases,numhid);
  posprods    = zeros(numdims,numhid);
  negprods    = zeros(numdims,numhid);
  vishidinc  = zeros(numdims,numhid);
  hidbiasinc = zeros(1,numhid);
  visbiasinc = zeros(1,numdims);
  batchposhidprobs=zeros(numcases,numhid,numbatches);
end

for epoch = epoch:maxepoch,
 fprintf(1,'epoch %d\r',epoch); 
 errsum(epoch)=0;
 errsum1(epoch)=0;
 errsum2(epoch)=0;
 errsum3(epoch)=0;
 for batch = 1:numbatches,
 fprintf(1,'epoch %d batch %d\r',epoch,batch); 

%%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  data = batchdata(:,:,batch);
  poshidprobs = 1./(1 + exp(-data*vishid - repmat(hidbiases,numcases,1)));
  batchposhidprobs(:,:,batch)=poshidprobs;
  posprods    = data' * poshidprobs;
  poshidact   = sum(poshidprobs);
  posvisact = sum(data);

%%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  poshidstates = poshidprobs > rand(numcases,numhid);

%%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  lambda=repmat(sum(data,2),1,numdims).*(exp(poshidstates*vishid' + repmat(visbiases,numcases,1))./repmat(sum(exp(poshidstates*vishid' + repmat(visbiases,numcases,1)),2),1,numdims));
  %negdata = lambda;             % Utilizar el valor esperado para reconstruir. Lambda sólo varía según la capa oculta.
  negdata = poissrnd(lambda);  % Generar aleatorio según poisson. Da un comportamiento completamente distinto en cada iteración, pero da un error bastante mayor.
  neghidprobs = 1./(1 + exp(-negdata*vishid - repmat(hidbiases,numcases,1)));
  negprods  = negdata'*neghidprobs;
  neghidact = sum(neghidprobs);
  negvisact = sum(negdata); 

%%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  err= (sum(sum( (data-negdata).^2 )))/numcases;
  err1 = (sum(sum( abs(data-negdata) )))/numcases;
  nonzerodata=data;
  nonzerodata(nonzerodata==0)=1;
  err2 = (sum(sum( abs(data-negdata)./nonzerodata )))/numcases;
  err3 = (sum(max( abs(data-negdata)./nonzerodata )))/numcases;
  errsum(epoch) = err + errsum(epoch);
  errsum1(epoch) = err1 + errsum1(epoch);
  errsum2(epoch) = err2 + errsum2(epoch);
  errsum3(epoch) = err3 + errsum3(epoch);

%%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    vishidinc = momentum*vishidinc + epsilonw*( (posprods-negprods)/numcases - weightcost*vishid);
    visbiasinc = momentum*visbiasinc + (epsilonvb/numcases)*(posvisact-negvisact);
    hidbiasinc = momentum*hidbiasinc + (epsilonhb/numcases)*(poshidact-neghidact);

    vishid = vishid + vishidinc;
    visbiases = visbiases + visbiasinc;
    hidbiases = hidbiases + hidbiasinc;

%%%%%%%%%%%%%%%% END OF UPDATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  end
  errsum(epoch)=errsum(epoch)/numbatches;
  errsum1(epoch)=errsum1(epoch)/numbatches;
  errsum2(epoch)=errsum2(epoch)/numbatches;
  errsum3(epoch)=errsum3(epoch)/numbatches;
  fprintf(1, 'epoch %4i error %6.1f error1 %6.1f error2 %6.1f error3 %6.1f\n', epoch, errsum(epoch), errsum1(epoch), errsum2(epoch), errsum3(epoch));
end;

fig = figure;
%plot([1:maxepoch],errsum,'b--o',[1:maxepoch],errsum1,'r--o',[1:maxepoch],errsum2,'g--o',[1:maxepoch],errsum3,'y--o');
plot([1:maxepoch],errsum1,'r--o',[1:maxepoch],errsum2,'g--o',[1:maxepoch],errsum3,'y--o');
legend('Error Abs por Palabra','Error Abs por Palabra / Palabra','Maximo Error abs por palabra')
title='CPM';
print(fig,title,'-dpng')