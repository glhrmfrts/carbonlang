@echo off

cd test_tuple_zeroinit
..\..\build\carbonc\Debug\carbonc.exe --embed-std --carbon-path /code/pl/carbon -o test.exe && test.exe > out.txt
cd ..

cd test_tuple_init
..\..\build\carbonc\Debug\carbonc.exe --embed-std --carbon-path /code/pl/carbon -o test.exe && test.exe > out.txt
cd ..

cd test_tuple_argument
..\..\build\carbonc\Debug\carbonc.exe --embed-std --carbon-path /code/pl/carbon -o test.exe && test.exe > out.txt
cd ..

cd test_slice_argument
..\..\build\carbonc\Debug\carbonc.exe --embed-std --carbon-path /code/pl/carbon -o test.exe && test.exe > out.txt
cd ..

type test_tuple_zeroinit\out.txt
type test_tuple_init\out.txt
type test_tuple_argument\out.txt
type test_slice_argument\out.txt