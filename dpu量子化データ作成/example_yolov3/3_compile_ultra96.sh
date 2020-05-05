#!/bin/bash

#Assume the dnnc-dpu1.3.0 is installed in /usr/local/bin
TARGET=ultra96v2_oob
NET_NAME=yolov3
DEPLOY_MODEL_PATH=vai_q_output
ARCH=/workspace/workspace_test/ultra96v2_oob.json

vai_c_caffe  --prototxt=3_model_after_quantize/deploy.prototxt \
              --caffemodel=3_model_after_quantize/deploy.caffemodel \
       	    --arch ${ARCH} \
              --output_dir=4_model_elf \
              --net_name=yolo
