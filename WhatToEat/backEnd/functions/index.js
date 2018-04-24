const functions = require('firebase-functions');
const admin = require('firebase-admin');
var firebase = admin.initializeApp(functions.config().firebase);

exports.dish = functions.https.onRequest((req, res) => {
    let key = req.query.key;
    var dishRef = firebase.database().ref('dishes').child(key);
    dishRef.once('value').then((snap) => {
        res.status(200).json({dish:snap.val()});
        return
    }).catch(() => {return;});
});

exports.getsaveforlater = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let dishListRef = firebase.database().ref('users').child(userId).child("save_for_later");
    
 
    dishListRef.once('value').then((dishListSnap) =>{
        res.status(200).json({dishes:dishListSnap.val()});
        return;
    }).catch(() => {return;});

});

exports.gethist = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let dishListRef = firebase.database().ref('users').child(userId).child("hist");
    
 
    dishListRef.once('value').then((dishListSnap) =>{
        res.status(200).json({dishes:dishListSnap.val()});
        return;
    }).catch(() => {return;});

});

exports.ratedish = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let histId= req.body.histId;
    let rating= req.body.rating;
    let histRecordRef = firebase.database().ref('users').child(userId).child("hist").child(histId);
    
    let updates = {};
    updates['rating'] = rating; 
    histRecordRef.update(updates);
    res.status(200).json({message:'updated'});

});

exports.saveforlater = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let dishId= req.body.dishId;
    let dishListRef = firebase.database().ref('users').child(userId).child("save_for_later");
    
    let d = new Date();
    dishListRef.push().set({
        'rating':0,
        'dateCreated': d.getTime(),
        'dishId': dishId
    })
    res.status(200).json({"message":"saved for later"});
});


///////////////////////////////////break/////////////////////////////////////////
///////////////////////////////////break/////////////////////////////////////////
///////////////////////////////////break/////////////////////////////////////////
///////////////////////////////////break/////////////////////////////////////////
///////////////////////////////////break/////////////////////////////////////////
///////////////////////////////////break/////////////////////////////////////////

exports.dishes = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let dishesRef = firebase.database().ref('dishes');
    let userRef = firebase.database().ref('users').child(userId);
    
    
    userRef.once('value').then((userSnap) =>{
        // let userInfo = {}; 
        // for(let key in userSnap){
        //    userInfo = userSnap[key]; 
        // }
        console.log(userSnap.val());
        
        dishesRef.once('value').then((dishSnap) => {
            dishesInfo = {};
            let count = 0;
            for(let key in dishSnap.val()){
                if(count > 20){
                    break;
                }
                dishesInfo[key] = dishSnap.val()[key];
                count += 1;
            }

            //TODO: recommendation algorithm
            
            res.status(200).json({dishes:dishesInfo});
            return;
        }).catch(() => {return;});
        return;
    }).catch(() => {return;});
});


exports.savehist = functions.https.onRequest((req, res) => {
    let userId= req.body.userId;
    let dishId= req.body.dishId;
    let dishListRef = firebase.database().ref('users').child(userId).child("hist");
    
    let d = new Date();
    dishListRef.push().set({
        'rating':0,
        'dateCreated': d.getTime(),
        'dishId': dishId
    })
    res.status(200).json({"message":"saved in history"});
});

