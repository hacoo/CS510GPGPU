function [] = cuda_test()
% This will run vector_addition.cu through MATLAB. To get it to
  % work, you need the following:
%
% vector_addition.cu must be in the current directory
  % You need to compile a .ptx file (and have that in the current dir
				     % too). To do this:
% nvcc -ptx vector_addition.cu

						     a = int32(1:8); % int32() converts to integers - otherwise
% MATLAB will assume you want an array of doubles
						     b = int32(9:16);

% Load the kernel
kernel = parallel.gpu.CUDAKernel('vector_addition.ptx', ...  
				 'vector_addition.cu', 'add_vectors_kernel');


% Transfer stuff to GPU memory (this is like a cudaMalloc call)
  a_dev = gpuArray(a);
b_dev = gpuArray(b);
result_dev = gpuArray(zeros(1,8,'int32'));

% Set grid/block dims
kernel.ThreadBlockSize = [4,1];
kernel.GridSize = [2,1];

% Even though the kernel doesn't return anything, MATLAB kernel eval
% does. I'm not sure why (but it works)
  result = feval(kernel, result_dev, a_dev, b_dev, 8);

disp('The result is.... ')
disp(result)

end
