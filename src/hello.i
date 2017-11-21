%module hello_swig

%{
#include "hello.h"
%}

namespace afo {
namespace cpp {

class Hello
{
	public:
	void say(char *name);
};

}
}
