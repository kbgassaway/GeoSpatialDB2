var express = require('express');
var mysql = require('./dbcon.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout: 'main'});
var bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(express.static('public'));
app.engine('handlebars',handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 8227);


//HOME Page
app.get('/', function(req,res,next){
    var context = {};
    mysql.pool.query('SELECT first_name, last_name, job_title, department, salary, city FROM employees e LEFT JOIN offices o ON e.office= o.id; ', function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        res.render('home');
    });
});

    app.get('/offices',function(req,res,next){
        res.render('offices');
    });
    app.get('/project_data',function(req,res,next){
        res.render('project_data');
    });
    app.get('/certifications',function(req,res,next){
        res.render('certifications');
    });
    app.get('/works_on',function(req,res,next){
        res.render('works_on');
    });
//Loads the existing table, if one exists
app.get('/loadTable', function(req,res,next){
    var context = {};
    mysql.pool.query('SELECT first_name, last_name, job_title, department, salary, city FROM employees e LEFT JOIN offices o ON e.office= o.id; ',function(err, rows, fields){
        if(err){
            next(err);
            return;                 
        }
        res.send(rows);
    });
});

app.get('/insert', function(req,res,next){
    var fname=req.query.first_name;
    var lname= req.query.last_name;
    var jtitle= req.query.job_title;
    var depart= req.query.department;
    var salary= req.query.salary;
    var city= req.query.office;
    //console.log(fname,lname,jtitle,depart,salary,city);
    mysql.pool.query("INSERT INTO employees(`first_name`,`last_name`,`job_title`,`department`,`salary`,`office`) VALUES (?,?,?,?,?,(Select id from offices where city =?))",
        [fname,lname,jtitle,depart,salary,city], function(err, result){
        if(err){
            next(err);
            return;
        }
        mysql.pool.query("SELECT first_name, last_name, job_title, department, salary, city FROM employees e LEFT JOIN offices o ON e.office= o.id", function(err, rows, fields){
            if(err){
                next(err);
                return;
            }
            res.send(rows);
        });    
    });
    
});

//Loads the Office location for the dynamic filter
app.get('/loadOffices', function(req,res,next){
    var context = {};
    mysql.pool.query('SELECT DISTINCT city FROM offices',function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        res.send(rows);
    });
});


//Loads the Employees Job Titles for the dynamic filter
app.get('/loadJobTitles', function(req,res,next){
    var context = {};
    mysql.pool.query('SELECT DISTINCT job_title FROM employees',function(err, rows, fields){
        if(err){
            next(err);
            return;
        }
        res.send(rows);
    });
});

//Loads the Employees table by the selected job_title
app.get('/fltrByJT', function(req,res,next){
    mysql.pool.query('SELECT first_name, last_name, job_title, department, salary, city FROM employees e LEFT JOIN offices o ON e.office= o.id WHERE job_title=?', [req.query.job_title], function(err, row, fields){
        if(err){
            next(err);
            return;
        }
        res.send(row);
    });
});


app.use(function(req,res){
    res.type('text/plain');
    res.status(404);
    res.send('404 - Not found');
});

app.use(function(err, req, res, next){
    console.error(err.stack);
    res.type('plain/text');
    res.status(500);
    res.send('500- Server Error');
});

app.listen(app.get('port'), function(){
    console.log('Express started on http://flip3.engr.oregonstate.edu:' +app.get('port') +';press Ctrl-C to terminate.');
});
