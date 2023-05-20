p=imread('box.png');
redLay=p(:,:,1);
greenLay=p(:,:,2);
blueLay=p(:,:,3);
imshow(uint8(cat(3,redLay,greenLay,blueLay)));