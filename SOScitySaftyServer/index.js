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
    if( Object.keys(centers).length==0) socket.emit("center_inactive");
  });

  socket.on("centerSignout",(id)=>{
    console.log("centerSignout: ",id);
    delete centers[socket.id];
    
    for (const key of Object.keys(clients)) {  
      console.log("clients to send disconect  call");
      console.log(key + ":" + clients[key])  ;
      clients[key].emit("centerDisconnected",socket.id);     
    }

    if( Object.keys(centers).length==0){
      console.log("clients to inavtive:");
      for (const key of Object.keys(clients)) {  
    
        console.log(key + ":" + clients[key])  
        clients[key].emit("center_inactive");   
      }
    }
  });

  socket.on("centerSignin",(id)=>{
    console.log("center Signin: ",id);
    console.log("centers size befor chek:", Object.keys(centers).length);
    if( Object.keys(centers).length==0){
      console.log("clients to avtive:");
      for (const key of Object.keys(clients)) {  
    
        console.log(key + ":" + clients[key])  
        clients[key].emit("center_active");   
      }
     
    } 
    centers[id]=socket;
    console.log("centers size afre: ", Object.keys(centers).length);
 
  });

  socket.on("disconnect",()=>{
  console.log(socket.id, "disconected");

   if(clients.hasOwnProperty(socket.id)) {
    console.log("client disconected");
     delete clients[socket.id];
     for (const key of Object.keys(centers)) {  
      console.log("centers to send disconect call");
      console.log(key + ":" + centers[key])  ;
      centers[key].emit("clientDisconnected",socket.id);     
    }
     
   }
      
   if(centers.hasOwnProperty(socket.id)){
    console.log("center disconected");
     delete centers[socket.id] ;
     for (const key of Object.keys(clients)) {  
      console.log("clients to send disconect  call");
      console.log(key + ":" + clients[key])  ;
      clients[key].emit("centerDisconnected",socket.id);     
    }

    if( Object.keys(centers).length==0){
      console.log("clients to inavtive:");
      for (const key of Object.keys(clients)) {  
    
        console.log(key + ":" + clients[key])  
        clients[key].emit("center_inactive");   
      }

}
}  
      

    
   });
   ///////////////////////////////////////////////
   socket.on("SOS_Call",(client)=>{
    console.log("SOS CALL from soket",socket.id);
    console.log(client);

    console.log("centers size", Object.keys(centers).length);
    if( Object.keys(centers).length==0) socket.emit("center_inactive");
    else socket.emit("sos_call_request_send",client);

    
    
    for (const key of Object.keys(centers)) {  
      console.log("center to send sos call");
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
    console.log("sos respone to ",client_socketId);
    console.log("from soket",socket.id);
    console.log(clients);
    if(clients[client_socketId]){
      console.log("SOS_Call_Respone to",client_socketId);
      clients[client_socketId].emit("SOS_Call_Respone",socket.id);

    }

    for (const key of Object.keys(centers)) {  
      console.log("centers to send sos call respone");
      console.log(key + ":" + centers[key]) ; 
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
    console.log("targitId: ", data['targetId']);
    socket.emit("message_send",data);
    if(centers[data['targetId']]){
      console.log("yes fount center");
      centers[data['targetId']].emit("get_message",{'sourceId':socket.id,'msg':data['msg']});
    
    }
    else if(clients[data['targetId']]){
      console.log("yes fount client");
      clients[data['targetId']].emit("get_message",data['msg']);
   
    }
    else {
      console.log("error on sending no target found");
      socket.emit("errorsend","targit not found");}


      for (const key of Object.keys(clients)) {  
        console.log("client key: ", key);
    
      }

    
 
   });

   socket.on("end_call",(clientId)=>{
    if(clients[clientId]){
      clients[clientId].emit("end_call"); }

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
    console.log("laterMessage:",msg);
    socket.emit("message_send",msg);

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