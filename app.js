var express = require('express'),
path = require('path'),
bodyParser = require('body-parser'),
cons = require('consolidate'),
dust = require('dustjs-helpers'),
 {pool,Client,pg} = require('pg'),
app = express();

// DB connection
const connectionString = "postgres://jacobwik:muJukH4tuuvA@nestor2.csc.kth.se:5432/jacobwik";

const client = new Client({
    connectionString:connectionString
})

app.get('/', function(req, res){
    // connectdddd
    client.query('SELECT * FROM books', function(err,result){
            
        if(err){
            return console.error('error running query', err);
        }
        res.render('index', {books: result.rows});
    });
});
client.connect();
// Assign Dust to .dust files
app.engine('dust', cons.dust);

// set .dust to Defoult Ext
app.set('view engine', 'dust');
app.set('views', __dirname + '/views');

// Set Public folder
app.use(express.static(path.join(__dirname, 'public')));

// Body Parser Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false}));


 

// server
app.listen(3000, function(){
console.log('server started on port 3000')
});

/*
app.get('/', function(req, res){
    // PG connect
    pg.connect(connect, function(err, client, done){
        if(err) {
            return console.error('error fetching client from pool', err);
        }
        client.query('SELECT * FROM books', function(err,result){
            
            if(err){
                return console.error('error running query', err);
            }
            res.render('index', {books: result.rows});
            done();
        });
    });
});*/

/*
app.get('/', function(req, res){
    // PG connect
    pg.connect(connect, function(err, client, done){
        if(err) {
            return console.error('error fetching client from pool', err);
        }
        
        client.query('SELECT * FROM users',(err,res)=>{
            console.log(err,res)
            client.end()
       
            if(err){
               return console.error('error running query', err);
           }
           res.render('index', {books: result.rows});
           done();
        });
    });
});*/