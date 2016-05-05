function [precision, recall] = evaluation_r(test_label, train_label, Dhat, r)
%
% Input:
%    train_label = train text categories
%    test_label = test text categories
%    Dhat  = estimated distances
%	 r 	   = radio
%
% Output:
%
%               exp. # of good pairs inside hamming ball of radius <= r
%  score(n) = --------------------------------------------------------------
%               exp. # of total pairs inside hamming ball of radius <= r
%
%               exp. # of good pairs inside hamming ball of radius <= r
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

Ntest = size(test_label,1);
Ntrain = size(train_label,1);
pairs_in_r=Dhat<=r;
mod_test_label=repmat(test_label,1,Ntrain);
mod_train_label=repmat(transpose(train_label),Ntest,1);
same_label = mod_test_label == mod_train_label;

tot_good_pairs_r = pairs_in_r==1 & same_label == pairs_in_r;
size(tot_good_pairs_r);
tot_good_pairs_r = sum(tot_good_pairs_r,2);
tot_good_pairs_test = tot_categoria(transpose(test_label));
tot_good_pairs_train = tot_categoria(transpose(train_label));
tot_pairs_in_r = sum(pairs_in_r,2);

precision = tot_good_pairs_r./ tot_pairs_in_r;
recall = tot_good_pairs_r./ tot_good_pairs_train;