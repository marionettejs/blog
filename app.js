var connect = require('connect'),
  app = connect.createServer(),
  port = '8080';

app.use(connect.static(__dirname + '/public'));
app.use(connect.compress());

app.listen(port, function(){
  console.log('Hexo is running on port %d', port);
});