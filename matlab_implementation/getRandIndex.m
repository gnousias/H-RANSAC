function [nA1,nB1,nA2,nB2]=getRandIndex(nA,nB)

    if length(nA)>1 & length(nB)>1
        % nA = f(imIdA,:);
        % nB = f(imIdB,:);
        [nmin,imin]=min([nA;nB]);

        for i=1:4
            c(i)=RouletteWheelSelection(nmin(1:2));
        end

        equal1 = sum(c==1);
        equal2 = sum(c==2);
        if equal1>nmin(1)
            change=equal1-nmin(1);
            id=find(c==1);
            c(id(1:change))=2;
        elseif equal2>nmin(2)
            change=equal2-nmin(2);
            id=find(c==2);
            c(id(1:change))=1;
        end
        equal1 = sum(c==1);
        equal2 = sum(c==2);

        nA1 = randperm(nA(1),equal1);
        nB1 = randperm(nB(1),equal1);
        nA2 = randperm(nA(2),equal2);
        nB2 = randperm(nB(2),equal2);
        % [nA1',nB1';nA2',nB2']
    else
        nA1 = randperm(nA,4);
        nB1 = randperm(nB,4);
        nA2 = -1;
        nB2 = -1;
    end
end