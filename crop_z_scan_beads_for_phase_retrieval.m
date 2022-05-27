
dataN =52;
PosN = [0:9,11:14,29,15:28];
fileFolder = 'E:\Experimental_data\20220429 A1-LCD\';
ROI_centery = [167,497]; 
ROI_centerx = [142,1269]; 
Nimg = 20;
load([fileFolder,'processed data\offset.mat']);
D = 41;
R = (D-1)/2;
count = 0;

for ii = 1:length(PosN)
SMLMName = ['_',num2str(dataN),'\_',num2str(dataN),'_MMStack_Pos', num2str(PosN(ii)),'.ome.tif'];

offset_ROIy = double(offset(ROI_centery(1)-R:ROI_centery(1)+R,ROI_centery(2)-R:ROI_centery(2)+R));
offset_ROIx = double(offset(ROI_centerx(1)-R:ROI_centerx(1)+R,ROI_centerx(2)-R:ROI_centerx(2)+R));
%

SMLM_imgR = Tiff([fileFolder,SMLMName],'r');
for i=1:Nimg
    count = count+1;
    setDirectory(SMLM_imgR,i);
    SMLM_img = double(SMLM_imgR.read);
    SMLM_img_ROIy = double(SMLM_img(ROI_centery(1)-R:ROI_centery(1)+R,ROI_centery(2)-R:ROI_centery(2)+R))-offset_ROIy;
    SMLM_img_ROIx = double(SMLM_img(ROI_centerx(1)-R:ROI_centerx(1)+R,ROI_centerx(2)-R:ROI_centerx(2)+R))-offset_ROIx;
    SMLM_img_save(:,:,count) = [SMLM_img_ROIx,SMLM_img_ROIy];
    
end

end
save([fileFolder,'processed data\data',num2str(dataN),'_beads1_L',num2str(ROI_centery(1)),'_',num2str(ROI_centery(2)),...
    '_R_',num2str(ROI_centerx(1)),'_',num2str(ROI_centerx(2)),...
     '_wo_offset_unfliped.mat'],"SMLM_img_save")
%%

