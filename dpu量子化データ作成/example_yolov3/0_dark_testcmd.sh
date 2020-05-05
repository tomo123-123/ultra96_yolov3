#!/bin/bash

#mkdir -p $(pwd)/results
#rm $(pwd)/results/*
#rm $(pwd)/5_file_for_test/yolov3_darknet_result.txt

../darknet_origin/darknet detector test  5_file_for_test/signate.data 0_model_darknet/yolov3.cfg 0_model_darknet/yolov3.weights 5_file_for_test/test.jpg
