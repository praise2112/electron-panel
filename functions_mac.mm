#import <AppKit/AppKit.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

#include "functions.h"

@interface PanelDelegate : NSObject <NSWindowDelegate>
@end

@interface Panel : NSPanel
@property(strong, nonatomic) NSWindow *originalWindow;
@end

@implementation PanelDelegate {
}

- (void) windowDidResize:(NSNotification *)notification {
  Panel* window = (Panel*)[notification object];
  [window.originalWindow setFrame:window.frame display:NO];
}

- (void) windowDidMove:(NSNotification *)notification {
  Panel* window = (Panel*)[notification object];
  [window.originalWindow setFrame:window.frame display:NO];
}

@end

@implementation Panel
@synthesize originalWindow;
@synthesize canBecomeKeyWindow;
- (id)init {
  self = [super init];
  if (self) {
    canBecomeKeyWindow = NO;
    self.delegate = [[PanelDelegate alloc] init];
  }
  return self;
}

@end

napi_value MakePanel(napi_env env, napi_callback_info info) {
  napi_status status;
  size_t argc = 1;
  napi_value handleBuffer[1];

  status = napi_get_cb_info(env, info, &argc, handleBuffer, 0, 0);
  if (status != napi_ok || argc < 1) {
    napi_throw_type_error(env, NULL, "Wrong number of arguments");
    return 0;
  }

  napi_handle_scope scope;
  status = napi_open_handle_scope(env, &scope);
  if (status != napi_ok) {
    return 0;
  }

  void *buffer;
  size_t bufferLength;
  status = napi_get_buffer_info(env, handleBuffer[0], &buffer, &bufferLength);
  if (status != napi_ok) {
    return handleBuffer[0];
  }
  NSView *mainContentView = *reinterpret_cast<NSView **>(buffer);
  if (!mainContentView)
    return handleBuffer[0];

  NSWindow *originalWindow = mainContentView.window;

  // Create NSPanel
  Panel *window = [[Panel alloc] init];
  [window setReleasedWhenClosed:YES];
  [window setOriginalWindow:originalWindow];

  [window setFrame:originalWindow.frame display:NO];
  [window setContentSize:mainContentView.frame.size];
  [window setContentMinSize:originalWindow.contentMinSize];
  [window setContentMaxSize:originalWindow.contentMaxSize];
  [window
      setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameDarkAqua]];
  [window setMovableByWindowBackground:YES];
  [window setFloatingPanel:YES];
  [window setLevel:NSFloatingWindowLevel];
  [window setCanHide:NO];
  [window setTitleVisibility:NSWindowTitleHidden];
  [window setTitlebarAppearsTransparent:YES];
  [window setStyleMask:NSWindowStyleMaskTitled |
                       NSWindowStyleMaskFullSizeContentView |
                       NSWindowStyleMaskNonactivatingPanel];

  if (originalWindow.resizable) {
    window.styleMask |= NSWindowStyleMaskResizable;
  }

  [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
                                NSWindowCollectionBehaviorFullScreenAuxiliary];

  [window setHidesOnDeactivate:NO];

  // Apply Vibrancy
  NSView *visualEffectRootView =
      [[NSVisualEffectView alloc] initWithFrame:mainContentView.frame];

  [visualEffectRootView
      setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

  [visualEffectRootView
      setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
  [visualEffectRootView setState:NSVisualEffectStateActive];
  [mainContentView addSubview:visualEffectRootView
                   positioned:NSWindowBelow
                   relativeTo:nil];

  // Move content to NSPanel
  [mainContentView removeFromSuperview];
  [window setContentView:mainContentView];
  [mainContentView viewDidMoveToWindow];

  status = napi_close_handle_scope(env, scope);
  if (status != napi_ok) {
    return 0;
  }

  return handleBuffer[0];
}

napi_value ShowPanel(napi_env env, napi_callback_info info) {
  napi_status status;
  size_t argc = 2;
  napi_value handleBuffer[2];

  status = napi_get_cb_info(env, info, &argc, handleBuffer, 0, 0);
  if (status != napi_ok || argc < 2) {
    napi_throw_type_error(env, NULL, "Wrong number of arguments");
    return 0;
  }

  napi_handle_scope scope;
  status = napi_open_handle_scope(env, &scope);
  if (status != napi_ok) {
    return 0;
  }

  void *buffer;
  size_t bufferLength;
  status = napi_get_buffer_info(env, handleBuffer[0], &buffer, &bufferLength);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  bool animate;
  status = napi_get_value_bool(env, handleBuffer[1], &animate);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  NSView *mainContentView = *reinterpret_cast<NSView **>(buffer);
  if (!mainContentView)
    return handleBuffer[0];

  Panel *window = mainContentView.window;

  if (animate) {
    // Hide the window at the start
    [window setAlphaValue:0.0];
    [window orderFrontRegardless];

    // Move the window down to its starting point
    NSRect originalFrame = [window frame];
    NSRect offsetFrame = NSOffsetRect(originalFrame, 0, -12);
    [window setFrame:offsetFrame display:true];

    // Animate the window back to its normal position and alpha
    [NSAnimationContext beginGrouping];
    [[window animator] setAlphaValue:1.0];
    [[window animator] setFrame:originalFrame display:true];
    [NSAnimationContext endGrouping];
  } else {
    [window orderFrontRegardless];
  }

  status = napi_close_handle_scope(env, scope);
  if (status != napi_ok) {
    return 0;
  }

  return handleBuffer[0];
}

napi_value HidePanel(napi_env env, napi_callback_info info) {
  napi_status status;
  size_t argc = 2;
  napi_value handleBuffer[2];

  status = napi_get_cb_info(env, info, &argc, handleBuffer, 0, 0);
  if (status != napi_ok || argc < 2) {
    napi_throw_type_error(env, NULL, "Wrong number of arguments");
    return 0;
  }

  napi_handle_scope scope;
  status = napi_open_handle_scope(env, &scope);
  if (status != napi_ok) {
    return 0;
  }

  void *buffer;
  size_t bufferLength;
  status = napi_get_buffer_info(env, handleBuffer[0], &buffer, &bufferLength);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  bool animate;
  status = napi_get_value_bool(env, handleBuffer[1], &animate);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  NSView *mainContentView = *reinterpret_cast<NSView **>(buffer);
  if (!mainContentView)
    return handleBuffer[0];

  Panel *window = mainContentView.window;

  if (animate) {
    // Animate the window alpha
    [NSAnimationContext beginGrouping];
    __block __unsafe_unretained Panel *_window = window;
    [[NSAnimationContext currentContext] setCompletionHandler:^{
      [_window orderOut:nil];
    }];
    [[window animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
  } else {
    [window orderOut:nil];
  }

  status = napi_close_handle_scope(env, scope);
  if (status != napi_ok) {
    return 0;
  }

  return handleBuffer[0];
}

napi_value ClosePanel(napi_env env, napi_callback_info info) {
  napi_status status;
  size_t argc = 2;
  napi_value handleBuffer[2];

  status = napi_get_cb_info(env, info, &argc, handleBuffer, 0, 0);
  if (status != napi_ok || argc < 2) {
    napi_throw_type_error(env, NULL, "Wrong number of arguments");
    return 0;
  }

  napi_handle_scope scope;
  status = napi_open_handle_scope(env, &scope);
  if (status != napi_ok) {
    return 0;
  }

  void *buffer;
  size_t bufferLength;
  status = napi_get_buffer_info(env, handleBuffer[0], &buffer, &bufferLength);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  bool animate;
  status = napi_get_value_bool(env, handleBuffer[1], &animate);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  NSView *mainContentView = *reinterpret_cast<NSView **>(buffer);
  if (!mainContentView)
    return handleBuffer[0];

  Panel *window = mainContentView.window;

  if (animate) {
    // Animate the window alpha
    [NSAnimationContext beginGrouping];
    __block __unsafe_unretained NSWindow *_originalWindow = window.originalWindow;
    __block __unsafe_unretained Panel *_window = window;
    [[NSAnimationContext currentContext] setCompletionHandler:^{
      [_originalWindow close];
      [_window close];
    }];
    [[window animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
  } else {
    [window.originalWindow close];
    [window close];
  }

  status = napi_close_handle_scope(env, scope);
  if (status != napi_ok) {
    return 0;
  }

  return handleBuffer[0];
}

napi_value Sync(napi_env env, napi_callback_info info) {
  napi_status status;
  size_t argc = 2;
  napi_value handleBuffer[2];

  status = napi_get_cb_info(env, info, &argc, handleBuffer, 0, 0);
  if (status != napi_ok || argc < 2) {
    napi_throw_type_error(env, NULL, "Wrong number of arguments");
    return 0;
  }

  napi_handle_scope scope;
  status = napi_open_handle_scope(env, &scope);
  if (status != napi_ok) {
    return 0;
  }

  void *buffer;
  size_t bufferLength;
  status = napi_get_buffer_info(env, handleBuffer[0], &buffer, &bufferLength);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  bool animate;
  status = napi_get_value_bool(env, handleBuffer[1], &animate);
  if (status != napi_ok) {
    return handleBuffer[0];
  }

  NSView *mainContentView = *reinterpret_cast<NSView **>(buffer);
  if (!mainContentView)
    return handleBuffer[0];

  Panel *window = mainContentView.window;
  NSWindow *originalWindow = window.originalWindow;

  [window setFrame:originalWindow.frame display:YES animate:animate];
  [window setContentMinSize:originalWindow.contentMinSize];
  [window setContentMaxSize:originalWindow.contentMaxSize];

  if (originalWindow.resizable) {
    window.styleMask |= NSWindowStyleMaskResizable;
  } else {
    window.styleMask &= ~NSWindowStyleMaskResizable;
  }

  NSSize size = originalWindow.aspectRatio;
  NSSize zeroSize = NSMakeSize(0.0, 0.0);
  NSLog(@"w: %f, h: %f", size.width, size.height);
  if (CGSizeEqualToSize(size, zeroSize)) {
    [window setResizeIncrements:NSMakeSize(1.0, 1.0)];
  } else {
    [window setAspectRatio:size];
  }

  status = napi_close_handle_scope(env, scope);
  if (status != napi_ok) {
    return 0;
  }

  return handleBuffer[0];
}
