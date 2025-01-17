%%w es una celda donde se le agregan la cantidad de capas que se quieran usar,
%%input_image, la imagen que se va a analizar, y 
%%correct_output, la salida o el numero al que corresponde la imagen
function [w] = DeepLearning (w,input_image,correct_output)
    alpha = 0.01;
    N = size(correct_output,1);
    
    for k = 1:N
       reshape_input_image = reshape(input_image(:,:,k),25,1); 
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
       output{size(w,2)} = Softmax(input{size(w,2)});
       
       correct_output_t = correct_output(k,:)';
       error = correct_output_t - output{size(w,2)};
       
       delta = error;
       
       for n = size(w,2):-1: 2 %Back propagation para actualizar los pesos seg�n el error
           error_n_layer = w{n}' * delta;
           w{n} = w{n} + alpha * delta * output{n - 1}';
           delta = (input{n - 1} > 0).* error_n_layer;
       end
       
       w{1} = w{1} + alpha * delta * reshape_input_image';
    end
end