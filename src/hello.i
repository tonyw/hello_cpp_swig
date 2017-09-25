%module afo

%{
#include "hello.h"
%}

class Hello
{
	public:
	void say(const std::string& name);
};