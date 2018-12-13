/*******************************************************************************
 * Name        : vxc_nn_dynamic_fixed_point_8.h
 * Author      : Your name
 * Copyright   : Your copyright notice
 * Description : Neural network header file generated by VivanteIDE
 *******************************************************************************/
#ifndef VXC_NN_DYNAMIC_FIXED_POINT_8_H
#define VXC_NN_DYNAMIC_FIXED_POINT_8_H

#ifdef __cplusplus
extern "C" {
#endif

#include "VX/vx.h"
#include "VX/vx_khr_cnn.h"

#define NN_INPUT_DIMENSION_NUMBER     4
#define NN_INPUT_WIDTH                416
#define NN_INPUT_HEIGHT               416
#define NN_INPUT_CHANNEL              3
#define NN_INPUT_DATA_FORMAT          VX_TYPE_INT8
#define NN_TENSOR_DATA_FORMAT_INT8
#define NN_INPUT_QUANT_TYPE                 VX_QUANT_DYNAMIC_FIXED_POINT
#define NN_INPUT_FIXED_POINT_POS            7

typedef struct tensors_info
{
    int size;
    vx_tensor *tensors;
} tensors_info_t;

vx_status vxcCreateNeuralNetwork(vx_graph graph, char* data_file_name, vx_tensor input, tensors_info_t *outputs_info);
void vxcReleaseNeuralNetwork();
#endif //VXC_NN_DYNAMIC_FIXED_POINT_8_H

#ifdef __cplusplus
}
#endif
