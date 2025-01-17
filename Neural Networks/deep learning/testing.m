load('DeepNeuralNetwork.mat');
input_Image = zeros(5,5,5);

%%Se modifican un poco las matrices para ver si sigue siendo capaz nuestra red neuronal de
%%identificarlas

input_Image(:,:,1) = [0 0 1 0 0;
                      0 1 1 0 0;
                      0 0 1 0 0;
                      0 0 1 0 0;
                      1 1 1 1 1];
           
input_Image(:,:,2) = [0 0 0 0 0;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      0 1 1 1 1;
                      0 0 0 0 0];
                
input_Image(:,:,3) = [0 0 0 0 1;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      1 1 1 1 0;
                      0 0 0 0 0];
                  
input_Image(:,:,4) = [1 1 1 0 1;
                      1 1 0 0 1;
                      1 0 1 0 1;
                      0 0 0 0 0;
                      1 1 1 0 1];
                  
input_Image(:,:,5) = [0 0 0 0 0;
                      0 1 1 1 1;
                      0 0 0 0 0;
                      1 1 1 1 0;
                      0 0 0 0 1];
                  
imagen_a_probar = input_Image(:,:,1);

reshape_input_image = reshape(imagen_a_probar,25,1);
input = cell(size(w));
output = cell(size(w));               
input{1} = w{1} * reshape_input_image;
output{1} = ReLU(input{1});

%Calculo de valores de las capas ocultas
for n = 2:size(w,2) - 1 
   input{n} = w{n} * output{n-1};
   output{n} = ReLU(input{n});
end

%Capa de salida, la cual tiene una funci�n de activacion diferente a
%las capas ocultas
input{size(w,2)} = w{size(w,2)} * output{size(w,2)-1};
salida = Softmax(input{size(w,2)});
[~,num]=max(salida);

num