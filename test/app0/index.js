const { app } = require('electron');
const { Panel } = require('../../index').init();

app.on('ready', function() {
  const mainWindow = new Panel({
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
  mainWindow.loadURL(`file://${__dirname}/index.html`);

  
  mainWindow.on('close', (e)=>{
    console.log("close")
  })

  mainWindow.on('closed', ()=>{
    console.log("closed")
  })

  // setTimeout(()=>{
  //   console.log("closing")
  //   console.log(mainWindow.close())
  // }, 5000)
});
