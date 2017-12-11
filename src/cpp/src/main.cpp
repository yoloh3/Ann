/**********************************************************************************************************
  DEMO CODE: XOR Backpropagation Example
  File: example.cpp
  Version: 0.1
  Copyright(C) NeuroAI (http://www.learnartificialneuralnetworks.com)
  Documentation: http://www.learnartificialneuralnetworks.com/neural-network-software/backpropagation-source-code/
  NeuroAI Licence:
  Permision granted to use this source code only for non commercial and educational purposes.
  You can distribute this file but you can't take ownership of it or modify it.
  You can include this file as a link on any website but you must link directly to NeuroAI website
  (http://www.learnartificialneuralnetworks.com)
  Written by Daniel Rios <daniel.rios@learnartificialneuralnetworks.com> , June 2013
*********************************************************************************************************/

#include <iostream>
#include "bpnet.h"
using    namespace std;
#define  PATTERN_COUNT  8
#define  PATTERN_SIZE 2
#define  NETWORK_INPUTNEURONS 2
#define  NETWORK_OUTPUT 2
#define  HIDDEN_LAYERCOUNT 1
#define  EPOCHS 10000



int main()
{
    //Create some patterns
    //playing with xor
    //XOR input values
    float pattern[PATTERN_COUNT][PATTERN_SIZE]=
    {
        {8,8},
        {8,5},
        {5,8},
        {5,5},
        {8,8},
        {8,5},
        {5,8},
        {5,5}
    };

    float desiredout[PATTERN_COUNT][NETWORK_OUTPUT]=
    {
        {1,0},
        {0,1},
        {0,1},
        {0,1},
        {1,0},
        {0,1},
        {0,1},
        {0,1}
    };


    bpnet net;//Our neural network object
    int   i,j;
    float error;
    //We create the network

    int *HIDDEN_LAYERS = new int[HIDDEN_LAYERCOUNT];
    for (i = 0; i < HIDDEN_LAYERCOUNT; i++) {
       HIDDEN_LAYERS[i] = 3;
    }

    net.create(PATTERN_SIZE,NETWORK_INPUTNEURONS,NETWORK_OUTPUT,HIDDEN_LAYERS,HIDDEN_LAYERCOUNT);

    //Start the neural network training
    for(i = 0 ; i < EPOCHS; i++)
    {
        error = 0;
        for(j = 0; j < PATTERN_COUNT; j++)
        {
            error += net.train(desiredout[j], pattern[j], 0.1f, 0.0f);
        }
        error     /= PATTERN_COUNT;
        //display error
    }

        cout << "ERROR: " << error << endl;
    //once trained test all patterns

    net.print_weight(); 

    for(i = 0; i < PATTERN_COUNT; i++)
    {

        net.propagate(pattern[i]);

        //display result
        //cout << "\nTESTED PATTERN " << i << " DESIRED OUTPUT: " << *desiredout[i] << " NET RESULT: ("<< net.getOutput().neurons[0]->output << ", " << net.getOutput().neurons[1]->output << ")" << endl;
    }

    return 0;
}

