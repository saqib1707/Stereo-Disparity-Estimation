import cv2
import numpy as np

img = cv2.imread('../dataset/barn1/im0.ppm')
gray= cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
sift = cv2.xfeatures2d.SIFT_create()
kp, des = sift.detectAndCompute(gray, None)
img=cv2.drawKeypoints(gray, kp)
cv2.imshow('sift image', img)