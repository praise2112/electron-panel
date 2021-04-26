const { app } = require('electron');
const { Panel } = require('../../index');

app.on('ready', function() {
  const mainWindow = new Panel({
    center: true,
    width: 320,
    height: 240,
    minHeight: 100,
    minWidth: 100,
    resizable: false,
    show: false,
    webPreferences: {
      preload: `${__dirname}/preload.js`,
    },
  });
  mainWindow.loadURL(`file://${__dirname}/index.html`);
  mainWindow.on('ready-to-show', () => {
    mainWindow.show(true);
  });
});
