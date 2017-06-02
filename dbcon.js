var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_whited6',
  password        : 'aMa1DAOl30S5Zas6',
  database        : 'cs340_whited6'
});

module.exports.pool = pool;
