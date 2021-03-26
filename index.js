const { BrowserWindow } = require('electron');
const NativeExtension = require('bindings')('NativeExtension');

// Only darwin supported for now
var isDarwin = process.platform === "darwin";

class Panel extends BrowserWindow {
  constructor(options) {
    super({ ...options, show: false });
    NativeExtension.MakePanel(this.getNativeWindowHandle());
    if (options.show) {
      this.show();
    }
  }

  show(animate) {
    animate = animate || false;
    NativeExtension.ShowPanel(this.getNativeWindowHandle(), animate);
  }

  hide(animate) {
    animate = animate || false;
    NativeExtension.HidePanel(this.getNativeWindowHandle(), animate);
  }

  close(animate) {
    animate = animate || false;
    NativeExtension.ClosePanel(this.getNativeWindowHandle(), animate);
  }

  destroy() {
    NativeExtension.ClosePanel(this.getNativeWindowHandle(), false);
  }

  setBounds(bounds, animate) {
    animate = animate || false;
    super.setBounds(bounds);
    NativeExtension.Sync(this.getNativeWindowHandle(), animate);
  }

  setPosition(x, y, animate) {
    animate = animate || false;
    super.setPosition(x, y);
    NativeExtension.Sync(this.getNativeWindowHandle(), animate);
  }

  setSize(w, h, animate) {
    animate = animate || false;
    super.setSize(w, h);
    NativeExtension.Sync(this.getNativeWindowHandle(), animate);
  }

  setMinimumSize(minWidth, minHeight) {
    super.setMinimumSize(minWidth, minHeight);
    NativeExtension.Sync(this.getNativeWindowHandle(), false);
  }
  
  setResizable(value) {
    super.setResizable(value);
    NativeExtension.Sync(this.getNativeWindowHandle(), false);
  }
  
  setAspectRatio(value) {
    super.setAspectRatio(value);
    NativeExtension.Sync(this.getNativeWindowHandle(), false);
  }
}

module.exports = {
  Panel: isDarwin ? Panel : BrowserWindow,
};
