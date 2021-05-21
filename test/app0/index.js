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
    show: true,
    webPreferences: {
      preload: `${__dirname}/preload.js`,
    },
  });
  mainWindow.loadURL(`file://${__dirname}/index.html`);


  // mainWindow.on('focus', ()=>{
  //   console.log('focus 1')
  // })

  // mainWindow.on('show', ()=>{
  //   console.log('show 1')
  // })

  // setTimeout(()=>{
  //   console.log('showuld shouw')
  //   mainWindow.show()
  // }, 5000)

  // setTimeout(()=>{
  //   console.log('showuld hide')
  //   mainWindow.hide()
  // }, 10000)

  // setTimeout(()=>{
  //   console.log('showuld shouw 2')
  //   mainWindow.show()
  //   mainWindow.focus()
  // }, 15000)


  
  
});
