#include "functions.h"

// NativeExtension.cc represents the top level of the module.
// C++ constructs that are exposed to javascript are exported here

#define DECLARE_NAPI_METHOD(name, func)                                        \
  { name, 0, func, 0, 0, 0, napi_default, 0 }

napi_value Init(napi_env env, napi_value exports) {
  napi_status status;

  napi_property_descriptor descriptors[] = {
      DECLARE_NAPI_METHOD("MakePanel", MakePanel),
      DECLARE_NAPI_METHOD("ShowPanel", ShowPanel),
      DECLARE_NAPI_METHOD("HidePanel", HidePanel),
      DECLARE_NAPI_METHOD("ClosePanel", ClosePanel),
      DECLARE_NAPI_METHOD("Sync", Sync)};

  status = napi_define_properties(env, exports, 5, descriptors);
  if (status != napi_ok)
    return NULL;
  return exports;
}

NAPI_MODULE(NativeExtension, Init)
