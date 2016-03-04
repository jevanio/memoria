%data = [1 2 3;4 5 6;7 8 9;1 2 3;4 5 6;7 8 9;1 2 3;4 5 6;7 8 9];
data=unidrnd(300,[100,2000]);
hidlay=zeros(size(data,1),2);
vishid = 0.01*randn(size(data,2), size(hidlay,2));
visbiases = zeros(1,size(data,2));
hidbiases = zeros(1,size(hidlay,2));
numcases=size(data,1);
maxepoch = 50;
epsilonw  = 0.1;
epsilonvb = 0.1;
epsilonhb = 0.1;
errsum=0;
%data=data./sum(data,2);
for epoch = 1:maxepoch
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
  neghidprobs = 1./(1+exp(-negdata*vishid -repmat(hidbiases,numcases,1)));
  negprods = data'*neghidprobs;
  neghidact = sum(neghidprobs);
  negvisact = sum(negdata);

  % End Negative 

  % Calcular Error
  err= sum(sum( (data-negdata).^2 ));
  errsum = errsum + err

  % Update
  vishidinc = epsilonw*( (posprods-negprods)/numcases);
  visbiasinc = (epsilonvb/numcases)*(posvisact-negvisact);
  hidbiasinc = (epsilonhb/numcases)*(poshidact-neghidact);
  vishid = vishid + vishidinc;
  visbiases = visbiases + visbiasinc;
  hidbiases = hidbiases + hidbiasinc;
end