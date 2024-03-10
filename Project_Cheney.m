% Close all graphics Windows
close all
% Clear workspace variable
clear
% Clear command window
clc
%% Read the image
% Add the template folder to the path
addpath("Template\");
% Read license plate picture
Plate_file=input('choose a plate image\n','s');
I1 = imread(Plate_file);
% Convert the image to type double
I = double(I1);
% Get image size
[M,N,~] = size(I);
disp(size(I));
imshow(I1);
disp('Finish');
%% Get the blue part of the image
% Extract the blue part of the image
bw = zeros(M,N);
% Algorithm from CSDN forum
bw(abs(I(:,:,1) - 50) < 30 & abs(I(:,:,2) - 90) < 20 & abs(I(:,:,3) - 180) < 25 ) = 1; 
imshow(bw);
disp('Finish');
%% Close operation smoothing contour
% Create a circular structure element with a radius of 5
se = strel('disk', 20); 
% Execution close operation
bw = imclose(bw, se);
imshow(bw);
%% Noise treatment ———— fill the void
bw = imfill(bw,'holes');
imshow(bw);
disp('Finish');
%% Determine the connected region in the image
% Converts binary images to logical images
labeledImg = logical(bw);
% Gets the properties of the connected region
props = regionprops(labeledImg, 'Area', 'BoundingBox');
disp(props);
disp("Finish");
%% Tempalte image
Template_Module='Template.jpg';
imshow(Template_Module);
%% Filter the connected domain with the largest area
% Extract the area information of the connected region
areas = [props.Area];
% Find the largest area and its index
[maxArea, maxIndex] = max(areas);
% Acquisition edge
boundingBox = props(maxIndex).BoundingBox;
disp(boundingBox);
%%  Edge detection
% Gets the coordinates of the four vertices
x1 = round(boundingBox(1));
y1 = round(boundingBox(2));
x2 = x1 + round(boundingBox(3)) - 1;
y2 = y1 + round(boundingBox(4)) - 1;
% Grey Processing
I1 = im2gray(I1);
imshow(I1);
%%  Extract the Chinese character
% Crop image
I1 = I1(y1:y2, x1:x2);
% binaryzation
binaryImg = imbinarize(I1,0.5);
% Defines an empty string to store what the image recognizes
str = '';
% Crop the binary image
binaryImg1 = binaryImg(25:end - 20,5:80);
% Call the Chinese character recognition function
shengfen = ['鄂','津','京','辽','鲁','陕','豫','粤','浙'];
num1 = Recognition_Chinese_Character(binaryImg1);
% Adds the recognized character to the string
str = strcat(str,shengfen(num1));
% Display the Chinese character
disp(str);
%% Extract the Letters and numbers
% Crop the image
binaryImg = binaryImg(:,80:end);
% Binaryzation
figure
imshow(binaryImg);
%% Connected region processing
% Binaryzation
labeledImg = bwlabel(binaryImg);
% Display the property
props = regionprops(labeledImg, 'Area', 'BoundingBox');
disp(props);
%% Compose the recognized characters into the license plate string
% Filter the connected domains with an area greater than 50
stats = props([props.Area] > 400);
m = 0;
qianmian = ['A','B','京','辽','鲁','陕','豫','粤','浙'];
% Loop through each target area
for i = 1:length(stats)
        % Edge detection
        boundingBox = stats(i).BoundingBox;
        x1 = round(boundingBox(1));
        y1 = round(boundingBox(2));
        x2 = x1 + round(boundingBox(3)) - 1;
        y2 = y1 + round(boundingBox(4)) - 1;
    % Determine whether to identify the current area based on the area width  
    if boundingBox(3) > 200 
        continue
    end
    m = m + 1;
        % According to the bounding box information
        % The current target area is extracted from the original binary image
        binaryImg1 = binaryImg(y1:y2, x1:x2, :);
        if m < 3
            order = Recognition_Letter(binaryImg1);
            ascii = order + 65;
            % Converts ASCII values to uppercase letters
            letter = char(ascii);
            str = strcat(str,string(letter));
        else
            n = Recognition_Num(binaryImg1);
            str = strcat(str,num2str(n));
        end
% Display the binarized images of recognized letters and numbers
figure
imshow(binaryImg1);  
end
%%
% Converts a num-string to a double-precision floating point number  
double_num = str2double(str);  
% Print the recognized license plate number in the command window
disp(str);
disp("The End");
%% ========================================================
% all the image I will also submit them into the cloudcampus in .exe
% =========================================================
%% Founction
% The template images come from the Internet
% Match the Chinese characters in the license plate number
function num_Ch = Recognition_Chinese_Character(img)
    % Read the Chinese character template picture
    Character=imread('Template\鄂.jpg');
    % Grey Processing
    Character=im2gray(Character);
    % Resize the image and binarize the image
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    % Template matching
    K0=Character;
    % Repeat the above steps
    Character=imread('Template\津.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K1_Ch=Character;
    Character=imread('Template\京.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K2_Ch=Character;
    Character=imread('Template\辽.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K3_Ch=Character;
    Character=imread('Template\鲁.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K4_Ch=Character;
    Character=imread('Template\陕.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K5_Ch=Character;
    Character=imread('Template\豫.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K6_Ch=Character;
    Character=imread('Template\粤.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K7_Ch=Character;
    Character=imread('Template\浙.jpg');
    Character=im2gray(Character);
    Character=imresize(imbinarize(Character,graythresh(Character)),size(img));
    K8_Ch=Character;
    % Template matching
    k_Ch=zeros(1,9);
    k_Ch(1)=corr2(img,K0);
    k_Ch(2)=corr2(img,K1_Ch);
    k_Ch(3)=corr2(img,K2_Ch);
    k_Ch(4)=corr2(img,K3_Ch);
    k_Ch(5)=corr2(img,K4_Ch);
    k_Ch(6)=corr2(img,K5_Ch);
    k_Ch(7)=corr2(img,K6_Ch);
    k_Ch(8)=corr2(img,K7_Ch);
    k_Ch(9)=corr2(img,K8_Ch);
    m_Ch=max(k_Ch);
    num_Ch=find(k_Ch==m_Ch);
end

% Matches the letters in the license plate
function num_Le = Recognition_Letter(img)
    % Read the letter template picture
    Letter=imread('Template\A.jpg');
    % Grey Processing
    Letter=im2gray(Letter);
    % Resize the image and binarize the image
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    % Template matching
    K0=Letter;
    % Repeat the above steps
    Letter=imread('Template\B.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K1_Le=Letter;
    Letter=imread('Template\C.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K2_Le=Letter;
    Letter=imread('Template\D.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K3_Le=Letter;
    Letter=imread('Template\E.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K4_Le=Letter;
    Letter=imread('Template\F.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K5_Le=Letter;
    Letter=imread('Template\G.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K6_Le=Letter;
    Letter=imread('Template\H.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K7_Le=Letter;
    Letter=imread('Template\I.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K8_Le=Letter;
    Letter=imread('Template\J.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K9_Le=Letter;
    Letter=imread('Template\K.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K10_Le=Letter;
    Letter=imread('Template\L.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K11_Le=Letter;
    Letter=imread('Template\M.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K12_Le=Letter;
    Letter=imread('Template\N.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K13_Le=Letter;
    Letter=imread('Template\O.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K14_Le=Letter;
    Letter=imread('Template\P.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K15_Le=Letter;
    Letter=imread('Template\Q.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K16_Le=Letter;
    Letter=imread('Template\R.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K17_Le=Letter;
    Letter=imread('Template\S.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K18_Le=Letter;
    Letter=imread('Template\T.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K19_Le=Letter;
    Letter=imread('Template\U.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K20_Le=Letter;
    Letter=imread('Template\V.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K21_Le=Letter;
    Letter=imread('Template\W.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K22_Le=Letter;
    Letter=imread('Template\X.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K23_Le=Letter;
    Letter=imread('Template\Y.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K24_Le=Letter;
    Letter=imread('Template\Z.jpg');
    Letter=im2gray(Letter);
    Letter=imresize(imbinarize(Letter,graythresh(Letter)),size(img));
    K25_Le=Letter;
    % Template matching
    k_Le=zeros(1,26);
    k_Le(1)=corr2(img,K0);
    k_Le(2)=corr2(img,K1_Le);
    k_Le(3)=corr2(img,K2_Le);
    k_Le(4)=corr2(img,K3_Le);
    k_Le(5)=corr2(img,K4_Le);
    k_Le(6)=corr2(img,K5_Le);
    k_Le(7)=corr2(img,K6_Le);
    k_Le(8)=corr2(img,K7_Le);
    k_Le(9)=corr2(img,K8_Le);
    k_Le(10)=corr2(img,K9_Le);
    k_Le(11)=corr2(img,K10_Le);
    k_Le(12)=corr2(img,K11_Le);
    k_Le(13)=corr2(img,K12_Le);
    k_Le(14)=corr2(img,K13_Le);
    k_Le(15)=corr2(img,K14_Le);
    k_Le(16)=corr2(img,K15_Le);
    k_Le(17)=corr2(img,K16_Le);
    k_Le(18)=corr2(img,K17_Le);
    k_Le(19)=corr2(img,K18_Le);
    k_Le(20)=corr2(img,K19_Le);
    k_Le(21)=corr2(img,K20_Le);
    k_Le(22)=corr2(img,K21_Le);
    k_Le(23)=corr2(img,K22_Le);
    k_Le(24)=corr2(img,K23_Le);
    k_Le(25)=corr2(img,K24_Le);
    k_Le(26)=corr2(img,K25_Le);
    m_Le=max(k_Le);
    num_Le=find(k_Le==m_Le)-1;
end

% Matches the number part of the license plate
function num_Num = Recognition_Num(img)
    % Read the digital template image
    Num=imread('Template\0.jpg');
    % Grey Processing
    Num=im2gray(Num);
    % Resize the image and binarize the image
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    % Template matching
    K0_Num=Num;
    % Repeat the above steps
    Num=imread('Template\1.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K1_Num=Num;
    Num=imread('Template\2.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K2_Num=Num;
    Num=imread('Template\3.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K3_Num=Num;
    Num=imread('Template\4.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K4_Num=Num;
    Num=imread('Template\5.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K5_Num=Num;
    Num=imread('Template\6.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K6_Num=Num;
    Num=imread('Template\7.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K7_Num=Num;
    Num=imread('Template\8.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K8_Num=Num;
    Num=imread('Template\9.jpg');
    Num=im2gray(Num);
    Num=imresize(imbinarize(Num,graythresh(Num)),size(img));
    K9_Num=Num;
    % Template matching
    k_Num=zeros(1,10);
    k_Num(1)=corr2(img,K0_Num);
    k_Num(2)=corr2(img,K1_Num);
    k_Num(3)=corr2(img,K2_Num);
    k_Num(4)=corr2(img,K3_Num);
    k_Num(5)=corr2(img,K4_Num);
    k_Num(6)=corr2(img,K5_Num);
    k_Num(7)=corr2(img,K6_Num);
    k_Num(8)=corr2(img,K7_Num);
    k_Num(9)=corr2(img,K8_Num);
    k_Num(10)=corr2(img,K9_Num);
    m_Num=max(k_Num);
    num_Num=find(k_Num==m_Num)-1;
end


