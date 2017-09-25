#include <iostream>
#include <string>
#include "hello.h"

using namespace afo::cpp;

void Hello::say(const std::string& name){
	std::cout<<"hello "<<name<<std::endl;
}
