function [team1Im1,team2Im1,team1Im2,team2Im2,nA,nB,allPoints,labelTeam1F1,labelTeam1F2,labelTeam2F1,labelTeam2F2] = decodeJsonFiles(jsonFile1,jsonFile2,game)
    files = {jsonFile1;jsonFile2};
%     disp(files(2));
    team1=game(1:3);
    team2=game(8:10);

    n=[];
    labelTeam1F1={}; labelTeam1F2={};
    labelTeam2F1={}; labelTeam2F2={};
    
    for k=1:size(files,1)
        A{k} = fileread(strtrim(cell2mat(files(k))));

        f = jsondecode(A{k});
        shapes = struct2table(f.shapes);

        counter=1;
        idPerson = {};
        c1=1;
        c2=1;
        c3=1;
        ofiPoints = [];
        aekPoints = [];
        refPoints = [];

        for i=1:size(shapes,1)
            if(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),team1))
%                 idPerson{counter} = {i 1};
                if k==1
                    labelTeam1F1{c1} = shapes.label(i);
                else
                    labelTeam1F2{c1} = shapes.label(i);
                end
                pt = cell2mat(shapes.points(i));
                ofiPoints(c1,:) = pt(2,:);
                c1 = c1+1;
                counter = counter+1;
            elseif(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),team2))
%                 idPerson{counter} = {i 2};
                if k==1
                    labelTeam2F1{c2} = shapes.label(i);
                else
                    labelTeam2F2{c2} = shapes.label(i);
                end
                pt = cell2mat(shapes.points(i));
                aekPoints(c2,:) = pt(2,:);
                c2 = c2+1;
                counter = counter+1;
            elseif(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),'REF_'))
%                 idPerson{counter} = {i 3};
                pt = cell2mat(shapes.points(i));
                refPoints(c3,:) = pt(2,:);
                c3 = c3+1;
                counter = counter+1;
            end
        end

        n = [n;c1-1,c2-1,c3-1];

        allPoints{k} = [ofiPoints' aekPoints' refPoints'];

        if ~isempty(ofiPoints)
            ofiPlayersPerFrame{k,1} = ofiPoints;
        else
            ofiPlayersPerFrame{k,1} = [];
        end
        if ~isempty(aekPoints)
            aekPlayersPerFrame{k,1} = aekPoints;
        else
            aekPlayersPerFrame{k,1} = [];
        end
        if ~isempty(refPoints)
            refPerFrame{k,1} = refPoints;
        else
            refPerFrame{k,1} = [];
        end

    end
    team1Im1 = cell2mat(ofiPlayersPerFrame(1))';
    team2Im1 = cell2mat(aekPlayersPerFrame(1))';
    team1Im2 = cell2mat(ofiPlayersPerFrame(2))';
    team2Im2 = cell2mat(aekPlayersPerFrame(2))';
    
    nA = n(1,:);
    nB = n(2,:);
end