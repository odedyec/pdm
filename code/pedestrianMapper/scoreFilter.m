function [matches,scores] = scoreFilter(matches,scores,framesL,framesR)
M=size(matches,2);
j=1;
while j~=M
    Ind = find(matches(2,:) == matches(2,j));
    if size(Ind,2) == 1
        j=j+1; continue
    end
    scoreTemp = [];
    scoreTemp = scores(Ind);
    [~,B]=min(scoreTemp);
    Ind(B)=[];
    for h=size(Ind,2):-1:1
            matches(:,Ind(h))=[];
            scores(:,Ind(h))=[];
            M=M-1;
    end
    j=j+1;
end
