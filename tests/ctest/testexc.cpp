#include <iostream>
#include <stdexcept>

class MyException : public std::exception
{
    int code;
public:
    explicit MyException(int co) : code{co} {}
};

extern void MyFunc(int a)
{
    if (a > 5)
    {
        throw MyException(5);
    }
}

int main()
{
    std::cout << "Nice" << std::endl;
}