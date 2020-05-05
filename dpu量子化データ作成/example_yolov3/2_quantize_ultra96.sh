#!/bin/bash
# Assume DECENT is already installed to /usr/local/bin
vai_q_caffe quantize -model 2_model_for_quantize/v3.prototxt \
                    -weights 2_model_for_quantize/v3.caffemodel \
                    -sigmoided_layers layer81-conv,layer93-conv,layer105-conv \
                    -output_dir 3_model_after_quantize \
                    -method 1 \
                    -calib_iter 30




