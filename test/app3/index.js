const { app, BrowserWindow } = require('electron');
const { Panel } = require('../../index');

app.on('ready', function() {
  const mainWindow = new BrowserWindow({
    center: true,
    width: 800,
    height: 600,
    minHeight: 100,
    minWidth: 100,
    show: true,
    webPreferences: {
      preload: `${__dirname}/preload.js`,
    },
  });
  mainWindow.loadURL(`file://${__dirname}/index.html`);

  const panel = new Panel({
    center: true,
    width: 320,
    height: 240,
    minHeight: 100,
    minWidth: 100,
    resizable: false,
    show: true,
    webPreferences: {
      preload: `${__dirname}/preload.js`,
    },
  });
  panel.loadURL(`file://${__dirname}/index.html`);
  setTimeout(() => panel.close());
  
});
