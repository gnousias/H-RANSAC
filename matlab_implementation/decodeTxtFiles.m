function [team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,labelTeam1F1,labelTeam1F2,labelTeam2F1,labelTeam2F2] = decodeTxtFiles(t1,t2)
team1Im1 = [];
team2Im1 = [];
team1Im2 = [];
team2Im2 = [];
labelTeam1F1 = [];
labelTeam2F1 = [];
labelTeam1F2 = [];
labelTeam2F2 = [];
nA=[]; nB=[];
nA1=0; nA2=0; nB1=0; nB2=0;
classA = cell2mat(table2cell(t1(:,3)));
classB = cell2mat(table2cell(t2(:,3)));

if size(t1,2)>2 & size(t2,2)>2
    for i=1:size(t1,1)
        if classA(i)==1
            team1Im1 = [team1Im1; t1(i,1:2)];
            labelTeam1F1 = [labelTeam1F1;classA(i)];
            nA1 = nA1+1;
        else
            team2Im1 = [team2Im1; t1(i,1:2)];
            labelTeam2F1 = [labelTeam2F1;classA(i)];
            nA2 = nA2+1;
        end
    end
    nA = [nA1,nA2];

    for j=1:size(t2,1)
        if classB(j)==1
            team1Im2 = [team1Im2; t2(j,1:2)];
            labelTeam1F2 = [labelTeam1F2;classB(j)];
            nB1 = nB1+1;
        else
            team2Im2 = [team2Im2; t2(j,1:2)];
            labelTeam2F2 = [labelTeam2F2;classB(j)];
            nB2 = nB2+1;
        end
    end
    nB = [nB1,nB2];

    team1Im1 = cell2mat(table2cell(team1Im1)); team1Im1 = team1Im1';
    team2Im1 = cell2mat(table2cell(team2Im1)); team2Im1 = team2Im1';
    team1Im2 = cell2mat(table2cell(team1Im2)); team1Im2 = team1Im2';
    team2Im2 = cell2mat(table2cell(team2Im2)); team2Im2 = team2Im2';
else
   t1 = cell2mat(table2cell(t1)); x = t1';  % points from candidate frame
   t2 = cell2mat(table2cell(t2)); y = t2';  % points from reference frame 
end
end