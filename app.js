var express = require('express'),
path = require('path'),
bodyParser = require('body-parser'),
cons = require('consolidate'),
dust = require('dustjs-helpers'),
 {Pool,Client,pg} = require('pg'),
app = express();

// Body Parser Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false}));
app.use(express.json());  // to support JSON-encoded bodies


// DB connection
const connectionString = "postgres://jacobwik:muJukH4tuuvA@nestor2.csc.kth.se:5432/jacobwik";

const client = new Client({
    connectionString:connectionString
})

const pool = new Pool({
    connectionString:connectionString
})

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err)
    process.exit(-1)
  })

app.get('/', function(req, res){
    // connectd
    client.query('SELECT * FROM users', function(err,result){
        if(err){
            return console.error('error running query', err);
        }
        res.render('users', {books: result.rows});
    });
});

app.get('/books', function(req, res){
    // connected
    //NATURAL JOIN "contProd_map"  NATURAL JOIN "contProducer"
    client.query('SELECT * FROM books NATURAL JOIN \"bookMap\"', function(err,result){
        if(err){
            return console.error('error running query', err);
        }
        res.render('books', {books: result.rows});
        
    });
});

    
app.post('/addBook',function(req,res){ 
    const query1 = {
        text: 'INSERT INTO books(\"mediaID\", title, genre, \"ISBN\", edition, language,'+ 
        'publisher, \"dateOfPublication\", pages, \"prequelID\", \"sequelID\", series)'+ 
        'VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 )',
        values: [req.body.mediaID, req.body.title, req.body.genre, req.body.ISBN, req.body.edition, 
            req.body.language, req.body.publisher, req.body.dateOfPublication, req.body.pages, req.body.prequelID, 
            req.body.sequelID, req.body.series],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query1);
    client.query(query1,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
        
   

    const query = {
        text: 'INSERT INTO \"bookMap\"(\"mediaID\", \"resourceID\")'+ 
        'VALUES($1, $2)',
        values: [req.body.mediaID, req.body.resourceID],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query);
    client.query(query,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
        
    });
});
    function function2() {
        res.redirect('books') 
        }
    setTimeout(function2, 500);
    
});

app.post('/addUser',function(req,res){
    const query = {
        text: 'INSERT INTO users(\"userID\", \"fullName\", email, \"bostadsAdress\", \"borrowedBooks\", \"dateOfBirth\")'+
        'VALUES($1, $2, $3, $4, 0, $5)',
        values: [req.body.userID, req.body.fullName, req.body.email, 
            req.body.bostadsAdress, req.body.dateOfBirth],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query);
    client.query(query,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
          
    

    if(req.body.rad == "student"){
        const query1 = {
            text: 'INSERT INTO students(\"userID\", programme)'+
            'VALUES($1, \'data\')',
            values: [req.body.userID],
        };
    
        pool.connect((err, client, done) => {
            if (err) throw err  
        console.log(query1);
        client.query(query1,(err, res) => {
            if (err) {
                console.log(err.stack)
              } else {
                console.log(res.rows[0])
              }
            });
            done();
            
        });
    }
    if(req.body.rad == "admin"){
        const query2 = {
            text: 'INSERT INTO admins(\"userID\", department, \"phoneNumber\", \"C/O-adress\", postnr, '+
            'postadress, \"privatePhone\") VALUES($1, \'\',\'\',\'\',\'\',\'\',\'\' )',
            values: [req.body.userID],
        };
    
        pool.connect((err, client, done) => {
            if (err) throw err  
        console.log(query2);
        client.query(query2,(err, res) => {
            if (err) {
                console.log(err.stack)
              } else {
                console.log(res.rows[0])
              }
            });
            done();
           
        });
        }
    });
    done();
}); 
    function function2() {
        res.redirect('/') 
        }
    setTimeout(function2, 500);
});

app.post('/updateBook',function(req,res){
    console.log("mediaID: "+req.body.mediaID)
    const query = {
        text: 'UPDATE books SET title = $2, genre = $3, \"ISBN\" = $4, edition = $5, language = $6,'+ 
        'publisher = $7, \"dateOfPublication\" = $8, pages = $9, \"prequelID\" = $10, \"sequelID\" = $11, series = $12 '+ 
        'WHERE \"mediaID\" = $1',
        values: [req.body.mediaID, req.body.title, req.body.genre, req.body.ISBN, req.body.edition, 
            req.body.language, req.body.publisher, req.body.dateOfPublication, req.body.pages, req.body.prequelID, 
            req.body.sequelID, req.body.series],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query);
    client.query(query,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });
    function function2() {
        res.redirect('books') 
        }
    setTimeout(function2, 500);
});

app.post('/updateUser',function(req,res){
    console.log("mediaID: "+req.body.mediaID)
    const query = {
        text: 'UPDATE users SET  \"fullName\" = $2, email = $3, \"bostadsAdress"\ = $4,'+ 
        '\"dateOfBirth\" = $5 WHERE \"userID\" = $1',
        values: [req.body.userID, req.body.fullName, req.body.email, req.body.bostadsAdress, req.body.dateOfBirth],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query);
    client.query(query,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });
    function function2() {
        res.redirect('/') 
        }
    setTimeout(function2, 500);
});

app.post('/deleteBook',function(req,res){
    const query = {
        text: 'DELETE FROM \"bookMap\" WHERE \"resourceID\"= $1;',
        values: [req.body.resourceID],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query);
    client.query(query,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });
    
    function function2() {
        res.redirect('books') 
        }
    setTimeout(function2, 500);
});

app.post('/deleteUser',function(req,res){
    const query1 = {
        text: 'DELETE FROM admins WHERE \"userID\"= $1;',
        values: [req.body.userID],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query1);
    client.query(query1,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });

    const query2 = {
        text: 'DELETE FROM students WHERE \"userID\"= $1;',
        values: [req.body.userID],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query2);
    client.query(query2,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });

    const query3 = {
        text: 'DELETE FROM users WHERE \"userID\"= $1;',
        values: [req.body.userID],
    };

    pool.connect((err, client, done) => {
        if (err) throw err  
    console.log(query3);
    client.query(query3,(err, res) => {
        if (err) {
            console.log(err.stack)
          } else {
            console.log(res.rows[0])
          }
        });
        done();
    });
    function function2() {
        res.redirect('/') 
        }
    setTimeout(function2, 500);
});

app.post('/filterUsers',function(req,res){
    var query = "SELECT * FROM USERS ";

    if(req.body.rad == "student"){
        query = query.concat("NATURAL JOIN students ");
    }
    if(req.body.rad == "admin"){
        query = query.concat('NATURAL JOIN admins ');
    }
    if(req.body.fullName){
        if(!query.includes('WHERE')){
            query = query.concat('WHERE ');
        }
        else{
            query = query.concat('AND ');
        }
        query = query.concat("lower(\"fullName\") LIKE \'%"+req.body.fullName+"%\'");

    }
    console.log(query)
    client.query(query, function(err,result){
            
        if(err){
            return console.error('error running query', err);
        }
        res.render('users', {books: result.rows});
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

// server
app.listen(3000, function(){
console.log('server started on port 3000')
});

/*<!-- Add Form Modal -->
    <div class="modal fade" id="formModal" tabindex="-1" role="dialog" aria-labelledby="formModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="post" action="/add">
                <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Add user</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Book name</label>
                        <input type="text" class="form-control" name="name"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <input type="submit" class="btn btn-primary" 
                    value="Save"/>
                </div>
                </form>
            </div>
        </div>
    </div>*/
    /*
    app.post('/addBook', function(req, res){
        console.log(req.body);
        client.query("INSERT INTO books(\"mediaID\", title, genre, \"ISBN\", edition, language",+ 
            "publisher, \"dateOfPublication\", pages, \"prequelID\", \"sequelID\", series)"+ 
            "VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 )", 
            [req.body.mediaID, req.body.title, req.body.genre, req.body.ISBN, req.body.edition, 
            req.body.language, req.body.publisher, req.body.dateOfPublication, req.body.pages, req.body.prequelID, 
            req.body.sequelID, req.body.series]);
        res.redirect('/books');
    });*/
    /*
    var books={
        "\"mediaID\"": req.body.mediaID,
        "title": req.body.title,
        "genre": req.body.genre,
        "\"ISBN\"": req.body.ISBN,
        "edition:": req.body.edition,
        "language":req.body.language,
        "publisher": req.body.publisher,
        "\"dateOfPublication\"": req.body.dateOfPublication,
        "pages": req.body.pages,
        "\"prequelID\"": req.body.prequelID,
        "\"sequelID\"": req.body.sequelID,
        "series": req.body.series
        }
        client.query('INSERT INTO books SET ?',Array.from(books)*/