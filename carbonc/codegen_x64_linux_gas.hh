#include <memory>
#include <string_view>

namespace carbon {
std::unique_ptr<codegen_x64_emitter> make_x64_linux_gas_emitter(std::string_view filename);
}