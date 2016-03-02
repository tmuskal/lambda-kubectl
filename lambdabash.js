/* 
*  lambdabash.js
*  Lambda Bash Function: nodejs to wrap and execute a Bash Shell Script 
*  Author: @JacobBaloul
*/

console.log('Loading Lambda Bash function');

/* aws lambda handler */
exports.handler = function(event, context) {

/* use spawn */
var util  = require('util'),
    spawn = require('child_process').spawn,

    // ex: execute shell command
    // bash    = spawn('ls', ['-lh', '/usr']); // the second arg is the command 
                                          // options
    // MAIN: call the shell script
    bash    = spawn('./core.sh', ['', '']); // [''] place holders for args 

    bash.stdout.on('data', function (data) {    // stdout handler
  	console.log('stdout: ' + data);
        context.succeed('stdout: ' + data);
	});

    bash.stderr.on('data', function (data) {	// stderr handler
	console.log('stderr: ' + data);
        context.fail('stderr: ' + data);
        // context.fail('Something went wrong');
	});

    bash.on('exit', function (code) {		// exit code handler
	console.log('lambda bash exited with code ' + code);
	});
};
