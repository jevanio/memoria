%data=unidrnd(300,[100,2000]);
data = 0.9 > rand(1000,2000);
hidlay=zeros(size(data,1),2);
vishid = normrnd(0,0.01,[size(data,2), size(hidlay,2)]);
visbiases = zeros(1,size(data,2));
hidbiases = zeros(1,size(hidlay,2));
numcases=size(data,1);

vishidinc  = zeros(size(vishid));
hidbiasinc = zeros(size(hidbiases));
visbiasinc = zeros(size(visbiases));

maxepoch = 10;

epsilonw      = 0.01;   % Learning rate for weights 
epsilonvb     = 0.01;   % Learning rate for biases of visible units 
epsilonhb     = 0.01;   % Learning rate for biases of hidden units 
weightcost  = 0.0002;   
momentum    = 0.9;

for epoch = 1:maxepoch
  data = 0.5 > rand(1000,2000);
  errsum=0;
  % Begin Positive

  poshidprobs = 1./(1+exp(-data*vishid -repmat(hidbiases,numcases,1)));
  posprods = data'*poshidprobs;
  poshidact=sum(poshidprobs);
  posvisact=sum(data);

  % End Positive
  poshidstates = poshidprobs > rand(numcases,size(hidlay,2));

  % Begin Negative
  lambda=repmat(sum(data,2),1,size(data,2)).*exp(poshidstates*vishid' + repmat(visbiases,numcases,1))./repmat(sum(exp(poshidstates*vishid' + repmat(visbiases,numcases,1)),2),1,size(data,2));
  %negdata = poissrnd(lambda);  % Generar aleatorio según poisson. Da un comportamiento completamente distinto en cada iteración, pero da un error bastante mayor.
  negdata = lambda;             % Utilizar el valor esperado para reconstruir. Lambda sólo varía según la capa oculta.
  %negdata = poisspdf(data,lambda);
  neghidprobs = 1./(1+exp(-negdata*vishid -repmat(hidbiases,numcases,1)));
  negprods = data'*neghidprobs;
  neghidact = sum(neghidprobs);
  negvisact = sum(negdata);

  % End Negative 

  % Calcular Error
  err= sum(sum( (data-negdata).^2 ));
  errsum = errsum + err

  % Update
  vishidinc = momentum*vishidinc + epsilonw*( (posprods-negprods)/numcases - weightcost*vishid);
  visbiasinc = momentum*visbiasinc + (epsilonvb/numcases)*(posvisact-negvisact);
  hidbiasinc = momentum*hidbiasinc + (epsilonhb/numcases)*(poshidact-neghidact);

  vishid = vishid + vishidinc;
  visbiases = visbiases + visbiasinc;
  hidbiases = hidbiases + hidbiasinc;
end