# MRF-MSSP_Model
This is a description of the model and example data presented in the paper titled "Object Based Markov Random Field Model for Hierarchical Semantic Segmentation of Remote Sensing Imagery"

The model is used for semantic segmentation of remote sensing images.

Note that hyperspectral or multispectral images need to be compressed into three-channel images so that the Gaussian distribution covariance matrices of the model do not become singular or near-singular matrices.

The model was coded and tested under _MATLABR2022b_.

**A note on data:**
https://drive.google.com/drive/folders/1Uq9RPxYqN4ZDlnOWzABc1FTsCKxC1MBr?usp=sharing
Place the file downloaded from the link into the Aerial image folder.
