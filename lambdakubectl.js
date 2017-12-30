/* 
 *  lambdakubectl.js
 *  Lambda Bash Function: nodejs to wrap and execute kubectl
 *  Author: Tal Muskal
 */

/* aws lambda handler */
exports.handler = function(event, context) {

    const params = event.params;
    const command = event.command;
    let stdin = event.stdin;
    if (typeof(stdin) === "object") {
        stdin = JSON.stringify(stdin);
    }
    params.push('--output');
    params.push('json');
    params.push('--kubeconfig');
    params.push('config');
    /* use spawn */
    let stdout = "";
    let strerr = "";
    var util = require('util'),
        spawn = require('child_process').spawn,
        bash = spawn('./bin/kubectl', params); // [''] place holders for args 


    bash.stdout.on('data', function(data) { // stdout handler
        console.log('stdout: ' + data);
        stdout = stdout + data;
    });

    bash.stderr.on('data', function(data) { // stderr handler
        console.log('stderr: ' + data);
        // context.fail('stderr: ' + data);
        strerr = strerr + data;
        // context.fail('Something went wrong');
    });

    bash.on('exit', function(code) { // exit code handler
        console.log('kubectl exited with code ' + code);
        if (code != 0) {
            context.fail({ code: code, strerr: strerr, stdout: stdout });
        }
        else {
            context.succeed({ code: code, strerr: strerr, stdout: stdout });
        }

    });
    if (stdin) {
        bash.stdin.write(stdin);
        bash.stdin.end();
    }
};


// todo: add kubectl call
