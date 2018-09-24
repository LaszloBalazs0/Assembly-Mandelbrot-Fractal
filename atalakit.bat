nasm -f win32 Mandelbrot2.1.asm
nlink Mandelbrot2.1.obj -lio -lutil -lgfx -o Mandelbrot2.1.exe
Mandelbrot2.1.exe