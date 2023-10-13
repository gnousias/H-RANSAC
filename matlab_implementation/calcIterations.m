% Function that estimates the necessary iterations to achieve an accurate
% result for homography estimation
% nA, nB: the number of points from each given set of points
% pr: (range 0 to 1) the percentage of correct inliers 
% isDataLabeled (boolean): 0 if data are not seperated in 2 classes
%                          1 if data are seperated in 2 classes
function niter = calcIterations(nA,nB,pr,isDataLabeled)
    if isDataLabeled
        nes=4;
        Na = nA(1)+nA(2);
        Nb = nB(1)+nB(2);
        k=min(Na,Nb);
        Ck4=nchoosek(k,nes);
        CNa4=nchoosek(Na,nes);
        CNb4=nchoosek(Nb,nes);
        p1=Ck4./CNa4;
        p2=Ck4./CNb4;
        p0=p1.*p2.*(1./(nchoosek(k,nes)*0.36))*(1./factorial(nes));
        niter=round(log10(1-pr)./log10(1-p0));
    else
        nes=4;   % necessary points (for Homography nes=4)
        k=min(nA,nB);
        Ck4=nchoosek(k,nes);
        CNa4=nchoosek(nA,nes);
        CNb4=nchoosek(nB,nes);
        p1=Ck4./CNa4;
        p2=Ck4./CNb4;
        p0=p1.*p2.*(1./(nchoosek(k,nes)))*(1./factorial(nes));
        niter=round(log10(1-pr)./log10(1-p0));
    end

end