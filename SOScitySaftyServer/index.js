const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//middlewre
app.use(express.json());
var clients={}
var centers={}


io.on("connection", (socket) => {
  console.log("connetetd");
  console.log(socket.id, "has joind");
  socket.on("/signin",(id)=>{
      console.log(id);
      clients[id]=socket;
     // console.log(clients);

  });

  socket.on("message",(msg)=>{
    console.log(msg);
    console.log(clients);
    let targitId=msg.targitId
    socket.emit("message",msg);
    if(clients['1']){
      console.log("yep");
      clients['1'].emit("message",msg);}
   });


   socket.on("SOS",(msg)=>{
    console.log("herrrrrrrr");
    console.log(msg);
    let targitId=msg.targitId
    socket.emit("message",msg);
    if(clients['1']){
      console.log("yep");
      clients['1'].emit("message",msg);}
   });
  
   
});
  


/////consol command("ipconfig") IPV4 addres;
server.listen(port, "0.0.0.0", () => {
  console.log("server started");
});