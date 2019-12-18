function [digits_set] = digit_segment(img)

% Implement the digit segmentation
% img: input image
% digits_set: a matrix that stores the segmented digits. The number of rows
%            equal to the number of digits in the iuput image. Each digit 
%            is stored in each row. Please make sure the segmented digit is a sqaure
%            image before expand it into a row vector.
    
    IM = rgb2gray(img);
    imgBW = edge(IM, "prewitt");
    S = sum(imgBW,2); %this should give an S that sums each row
    
    MAX = max(S);
    segment_list={};
    curr_segment=[];
    threshold = 0.05*max(MAX);
    
    for i = 1:size(S)
        if S(i)>0
            curr_segment = [curr_segment; imgBW(i,:)];
        else
            if size(curr_segment)==0
                continue
            end
            segment_list{end+1} = curr_segment;
            curr_segment = [];
        end
    end
    
    final_list = {};
    
    for j = 1:size(segment_list,2)
        ass = segment_list{j}.';
        D = sum(ass,2); %this should give an S that sums each row
        
        MAX = max(D);
        curr_segment=[];
        threshold = 0.05*max(MAX);

        for i = 1:size(D)
            if D(i)>0
                curr_segment = [curr_segment; ass(i,:)];
            else
                if size(curr_segment)==0
                    continue
                end
                final_list{end+1} = curr_segment.';
                curr_segment = [];
            end
        end
    end
    
    pad = 0;
    for i = 1:size(final_list,2)
        if max(size(final_list{i}))>pad
            pad = max(size(final_list{i}));
        end
    end
    
    digits_set = [];
    for i = 1:size(final_list,2)
        ass = final_list{i};
        add = padarray(ass,[pad-size(ass,1) pad-size(ass,2)],0,'pre');
        digits_set = [digits_set; reshape(add,1,[])];
        
        %if size(digits_set)==0
        %    digits_set = add;
        %else
        %    digits_set = cat(3,digits_set, add); 
        %end
    end
    
    digits_set;
    