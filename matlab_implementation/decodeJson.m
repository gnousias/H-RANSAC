function [n]=decodeJson(jsonFile)
A = fileread(strtrim(jsonFile));
f = jsondecode(A);
if size(f.shapes,1)==1
    shapes = struct2table(f.shapes,'AsArray',1);
else
    shapes = struct2table(f.shapes);
end

counter=1;
idPerson = {};
c1=1;
c2=1;
c3=1;
ofiPoints = [];
aekPoints = [];
refPoints = [];

for i=1:size(shapes,1)
    if(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),'OFI_'))
        idPerson{counter} = {i 1};
        pt = cell2mat(shapes.points(i));
        ofiPoints(c1,:) = pt(2,:);
        c1 = c1+1;
        counter = counter+1;
    elseif(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),'AEK_'))
        idPerson{counter} = {i 2};
        pt = cell2mat(shapes.points(i));
        aekPoints(c2,:) = pt(2,:);
        c2 = c2+1;
        counter = counter+1;
    elseif(shapes.shape_type(i) == "rectangle" && contains(shapes.label(i),'REF_'))
        idPerson{counter} = {i 3};
        pt = cell2mat(shapes.points(i));
        refPoints(c3,:) = pt(2,:);
        c3 = c3+1;
        counter = counter+1;
    end
end

n = [c1-1,c2-1,c3-1];
end