const express = require("express");
const req = require("express/lib/request");
const res = require("express/lib/response");
var http = require("http");
const { fileURLToPath } = require("url");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//middlewre
app.use(express.json());
var clients={}
var centers={}
var laterMesages={}
var i=0;

io.on("connection", (socket) => {
  console.log("connetetd");
  console.log(socket.id, "has joind");


  socket.on("clientSignin",(id)=>{
    console.log("client signin: ",id);
    clients[id]=socket;

  });

  socket.on("centerSignin",(id)=>{
    console.log("center Signin: ",id);
    centers[id]=socket;
  });

  socket.on("disconnect",()=>{
    console.log(socket.id, "disconected");
    clients.hasOwnProperty(socket.id) // true
      delete clients[socket.id]
      centers.hasOwnProperty(socket.id) // true
      delete centers[socket.id] 

    
   });
   ///////////////////////////////////////////////
   socket.on("SOS_Call",(client)=>{
    console.log("SOS CALL");
    console.log(client);
    console.log("from soket",socket.id);
    if(clients[socket.id])clients[socket.id].emit("sos_call_request_send",client);
    for (const key of Object.keys(centers)) {  
      console.log("centers to send sos call");
      console.log(key + ":" + centers[key])  
      centers[key].emit("SOS_Call",{'client_socketId':socket.id,'client':client});     
    }
   });


   socket.on("SOS_Call_Test",(data)=>{
    console.log("SOS CALL Test");
   
    for (const key of Object.keys(centers)) {  
      console.log("centers to send sos call");
      console.log(key + ":" + centers[key])  
      centers[key].emit("SOS_Call",{'client_socketId':data['socketId'],'client':data['client']});    
    }
   });

   socket.on("SOS_Call_Respone",(client_socketId)=>{
    console.log("SOS_Call_Respone");
    console.log(client_socketId);
    console.log("from soket",socket.id);
    if(clients[client_socketId])clients[client_socketId].emit("SOS_Call_Respone",socket.id);

    for (const key of Object.keys(centers)) {  
      console.log("centers to send sos call");
      console.log(key + ":" + centers[key])  
     if(key.localeCompare(socket.id)) centers[key].emit("SOS_Call_Respone",client_socketId);    
    }


    

    for (const key of Object.keys(laterMesages)) {  
      console.log(key + ":" + laterMesages[key])
      if(laterMesages[key]['sourceId']==client_socketId)  {
       centers[socket.id].emit("get_message",{'sourceId':client_socketId,'msg':laterMesages[key]['msg']});
       delete laterMesages[key];
      }
    
    }

    

   });

   socket.on("message",(data)=>{
    console.log("msg: ",data['msg']);
    console.log(data);
    socket.emit("message_send",data);
    if(centers[data['targitId']]){
      centers[data['targitId']].emit("get_message",{'sourceId':socket.id,'msg':data['msg']});
    
    }
    if(clients['targitId']){
      clients[data['targitId']].emit("get_message",data['msg']);
   

    }
    else {socket.emit("errorsend","targit not found");}

    
 
   });


   socket.on("message_test",(data)=>{
    console.log("message_test: ",data['msg']);
    console.log(data);
    if(centers[data['targitId']]){
      centers[data['targitId']].emit("get_message",{'sourceId':data['sourceId'],'msg':data['msg']});
    
    }
    if(clients['targitId']){
      clients[data['targitId']].emit("get_message",data['msg']);
   

    }
    else {socket.emit("errorsend","targit not found");}

    
 
   });

   socket.on("laterMessage",(msg)=>{
    console.log("laterMessage:",'msg');

    laterMesages[i]={'sourceId':socket.id,'msg':msg};
    i++;


 
   });


   socket.on("cancel",()=>{
    console.log("cancel call");
  

    for (const key of Object.keys(centers)) {  
      console.log("centers to send cancel");
      console.log(key + ":" + centers[key])  
      centers[key].emit("cancel",socket.id);     
    }
});


 
  
   
});

/////////////////////////////////////////////////////////////////////////////////////
app.route("/chek").get((req,res)=>{
  return res.json("your App is working fine");
});
  
/////consol command("ipconfig") IPV4 addres;
server.listen(port, "0.0.0.0", () => {
  console.log("server started");
});