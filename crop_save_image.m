
for dataN =[20:24]
fileFolder = 'E:\Experimental_data\20220429 A1-LCD\';
SMLMName = ['_',num2str(dataN),'\_',num2str(dataN),'_MMStack_Default.ome.tif'];
load(strcat(fileFolder,'processed data\saved_beads_loc_for_tform\tformx2y_y_center_466_327_FoV_150.mat'));
ROI_centerY = [466,327]; 
W = 1748/2;
ROI_centerX = transformPointsInverse(tformx2y,[W,0]+[-ROI_centerY(1),ROI_centerY(2)])+[W,0];

Nimg = 2000;
FoV = [101,101]; 
N_FoV = [1,1];
FoV_each = 101;

center_x = FoV(1)/N_FoV(1)/2*[-N_FoV(1)+1:2:N_FoV(1)-1];
center_y = FoV(2)/N_FoV(2)/2*[-N_FoV(2)+1:2:N_FoV(2)-1];
[center_X,center_Y] = meshgrid(center_x,center_y);
center_X = center_X(:);
center_Y = center_Y(:);
% if rem(N_FoV(1),2)==0 & rem(N_FoV(1),2)==0
%      center_X= [center_X;0];
%     center_Y = [center_Y;0];
% end
% count = 0;


for ii = 1:length(center_X)

%count = count+1;
range = round(-(FoV_each-1)/2):1:round((FoV_each-1)/2);
SMLM_save_Nmae = ['processed data\data',num2str(dataN),'_centerY_y',num2str(ROI_centerY(1)),'_x_',num2str(ROI_centerY(2)),'_','FoV',num2str(FoV(1)),'_',num2str(FoV(2)),'_',num2str(ii),'th_FoV','.tif'];

ROI_centerY_cur = round(ROI_centerY+[center_X(ii),center_Y(ii)]);
ROI_centerX_cur = round(transformPointsInverse(tformx2y,[W,0]+[-ROI_centerY_cur(1),ROI_centerY_cur(2)])+[W,0]);
SMLM_imgR = Tiff([fileFolder,SMLMName],'r');


for i=1:Nimg

    setDirectory(SMLM_imgR,i);
    SMLM_img = double(SMLM_imgR.read);
    SMLM_img_ROIy = uint16(SMLM_img(ROI_centerY_cur(2)+range,ROI_centerY_cur(1)+range));
    SMLM_img_ROIx = uint16(SMLM_img(ROI_centerX_cur(2)+range,ROI_centerX_cur(1)+range));
    SMLM_img = [SMLM_img_ROIx,fliplr(SMLM_img_ROIy)];
    

    if i==1
     imwrite(SMLM_img,[fileFolder,SMLM_save_Nmae])
    else
    imwrite(SMLM_img,[fileFolder,SMLM_save_Nmae],'WriteMode','append')
    end
end
end
end

%%
