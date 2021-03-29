{
    "targets": [
        {
            "target_name": "NativeExtension",
            "sources": [ ],
            "link_settings": {
              "conditions":[
                  ['OS=="mac"', {
                      "sources": [
                        "NativeExtension.mm",
                          "functions_mac.mm"
                      ],
                      "libraries": [
                          'Foundation.framework',
                          'AppKit.framework',
                          'ScriptingBridge.framework'
                      ]
                  }
              ]]
            },
            "xcode_settings": {
                "OTHER_CFLAGS": [
                    "-x objective-c++ -stdlib=libc++"
                ]
            }
        }
    ],
}